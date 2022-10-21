# frozen_string_literal: false

require 'appifier'
require 'thor'

require_relative 'commands/init'



Dir["#{File.dirname(__FILE__)}/cli/*.rb"].sort.each { |file| require file }

module Appifier
  module CLI
    # The CLI Command structure for Thor
    class MainCommand < Thor


      def initialize(*args)
        super
        @output = Carioca::Registry.get.get_service name: :output
      end

      # callback for managing ARGV errors
      def self.exit_on_failure?
        true
      end

      desc 'templates SUBCOMMAND ...ARGS', 'Managing apps templates'
      subcommand 'templates', Subcommands::Templates

      desc 'configuration SUBCOMMAND ...ARGS', 'Configuration commands for Appifier'
      subcommand 'configuration', Subcommands::Configuration

      # Thor method : running of Appifier generate
      desc 'generate TEMPLATE [TARGET]', 'Generate application from bundled template'
      long_desc <<-LONGDESC
            Generate application from bundled template\n
            with --simulate, only simulate folders and files installed#{' '}
            with --force, force regeneration of application, remove old files [DANGER]#{'  '}
      LONGDESC
      option :simulate, type: :boolean, aliases: '-s'
      option :force, type: :boolean, aliases: '-F'
      def generate(template, target = '.')
        source = "#{File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)}/#{template}"
        begin
          generator = Appifier::Actors::Generator.new src_root: source, target_root: File.expand_path(target)
          generator.generate dry_run: options[:simulate], force: options[:force]
        rescue RuntimeError => e
          @output.error e.message
        end
      end

      # Thor method : running of Appifier reteive
      desc 'retrieve ORIGIN', 'Retrieve an application template in user templates bundle'
      long_desc <<-LONGDESC
             Retrieve an application template in user templates bundle\n
             with --type [RETRIEVER], precise retrieving type ex,builtin [:git,:archive]
      LONGDESC
      option :type, type: :string, aliases: '-t', default: 'git'
      def retrieve(origin)
        begin
          type = options[:type].to_sym
          retriever = Appifier::Actors::Retriever.new type: type, origin: origin
          retriever.get
        rescue RuntimeError => e
          @output.error e.message
        end
      end
    end
  end
end
