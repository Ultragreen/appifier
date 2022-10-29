# frozen_string_literal: false

require 'appifier'

Dir["#{File.dirname(__FILE__)}/cli/*.rb"].sort.each { |file| require file }

module Appifier
  module CLI
    # The CLI Command structure for Thor
    class MainCommand < Thor


      def initialize(*args)
        super
        @output = Carioca::Registry.get.get_service name: :output
        @finisher = Carioca::Registry.get.get_service name: :finisher
      end

      # callback for managing ARGV errors
      def self.exit_on_failure?
        true
      end

      desc 'datasets SUBCOMMAND ...ARGS', 'Managing apps datasets'
      subcommand 'datasets', Subcommands::Datasets

      desc 'templates SUBCOMMAND ...ARGS', 'Managing apps templates'
      subcommand 'templates', Subcommands::Templates

      desc 'configuration SUBCOMMAND ...ARGS', 'Configuration commands for Appifier'
      subcommand 'configuration', Subcommands::Configuration

      # Thor method : running of Appifier generate
      desc 'generate TEMPLATE [TARGET]', 'Generate application from bundled template (IF TARGET ommited use the current path as ROOTPATH)'
      long_desc <<-LONGDESC
            Generate application from bundled template\n
            (IF TARGET ommited use the current path as ROOTPATH)\n
            with --simulate, only simulate folders and files installed\n
            with --force, force regeneration of application, remove old files [DANGER]
      LONGDESC
      option :simulate, type: :boolean, aliases: '-s'
      option :force, type: :boolean, aliases: '-F'
      def generate(template, target = '.')
        root = "#{File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)}/#{template}"
        unless File::exist? root 
          @output.error "Template not found #{template}"
          @finisher.terminate exit_case: :error_exit
        end
        if File::exist? File::expand_path("#{DEFAULT_DATASETS_PATH}/#{template}.yml") then
          dataset = open_dataset(template: template)
          @output.info "Dataset file found for #{template}"
        else
          begin 
            @output.warn "Dataset file not found for #{template}"
            if TTY::Prompt.new.yes?("Do you want to collect dataset interactively ?")
              @output.info "Beginning interactive Dataset input for #{template}"
              collector = Appifier::Actors::Collector.new template: template
              collector.collect 
              dataset = open_dataset(template: template)
            else
              puts "=> Exiting run 'appifier collect #{template}' for collecting data"
              puts " (use -S for collecting from STDIN or -f <FILE>)  "
              @finisher.terminate exit_case: :quiet_exit
            end
          rescue TTY::Reader::InputInterrupt
            @output.warn "Command interrupted"
            @finisher.terminate exit_case: :interrupt
          end
        end

        begin
          generator = Appifier::Actors::Generator.new template_root: root, target_root: File.expand_path(target), dataset: dataset
          generator.generate dry_run: options[:simulate], force: options[:force]
          @finisher.terminate exit_case: :quiet_exit
        rescue RuntimeError => e
          @output.error e.message
          @finisher.terminate exit_case: :error_exit
        end
      end

      # Thor method : running of Appifier retreive
      desc 'retrieve ORIGIN', 'Retrieve an application template in user templates bundle'
      long_desc <<-LONGDESC
             Retrieve an application template in user templates bundle\n
             with --type [RETRIEVER], precise retrieving type ex,builtin [:git,:archive] DEFAULT : :git
      LONGDESC
      option :type, type: :string, aliases: '-t', default: 'git'
      def retrieve(origin)
        begin
          type = options[:type].to_sym
          retriever = Appifier::Actors::Retriever.new type: type, origin: origin
          results = retriever.get
          @output.info "Detail of notifications : " unless results[:error].empty? and results[:warn].empty? and results[:cleaned].empty?
          [:error, :warn].each do |level|
            results[level].each { |value| @output.send level, "#{level.to_s} : #{value}" }
          end
          results[:cleaned].each { |value| @output.ok "cleaned : #{value}" }
          @finisher.terminate exit_case: :error_exit unless results[:error].empty?
          @finisher.terminate exit_case: :quiet_exit
        rescue RuntimeError => e
          @output.error e.message
          @finisher.terminate exit_case: :error_exit
        end
      end

      # Thor method : running of Appifier Dataset Collector
      desc 'collect TEMPLATE', 'Collect dataset for an application template in user templates bundle'
      long_desc <<-LONGDESC
            Collect dataset for an application template in user templates bundle\n
            with --force => force collect, and destroy previous Dataset [DANGER]\n
            with --file FILENAME get data from à YAML File\n
            with --stdin get data from STDIN

      LONGDESC
      option :force, type: :boolean, aliases: '-F'
      option :stdin, type: :boolean, aliases: '-S'
      option :file, type: :string, aliases: '-f'
      def collect(template)
        data = nil
        begin
          raise "Options incompatibles --file and --stdin" if options[:stdin] and options[:file]
          @output.info "Force mode, rewrite dataset if exist" if options[:force]
          if options[:file]
            Appifier::Actors::Collector.new template: template, dataset: open_yaml(filename: options[:file]), force: options[:force]
            @output.info "Getting Dataset from file : #{options[:file]} for #{template}"
          elsif options[:stdin]
            @output.info "Getting Dataset from STDIN for #{template}"
            begin 
              data = STDIN.readlines.join
            rescue Interrupt
              @output.error "Dataset input from STDIN cancelled"
              @finisher.terminate exit_case: :interrupt
            end
            Appifier::Actors::Collector.new template: template, dataset: YAML::load(data), force: options[:force]
          else
            @output.info "Beginning interactive Dataset input for #{template}"
            collector = Appifier::Actors::Collector.new template: template, force: options[:force]
            collector.collect 
          end
          @finisher.terminate exit_case: :quiet_exit
        rescue RuntimeError => e
          @output.error e.message
          @finisher.terminate exit_case: :error_exit
        rescue 
          
        end
      end

    end
  end
end
