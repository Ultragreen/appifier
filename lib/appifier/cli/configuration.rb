# frozen_string_literal: true

module Appifier
  module CLI
    module Subcommands
      class Configuration < ::Thor

        def initialize(*args)
          super
          @output = Carioca::Registry.get.get_service name: :output
          @finisher = Carioca::Registry.get.get_service name: :finisher
        end

        # Thor method : running of Appifier sanitycheck
        desc 'sanitycheck', 'Verify installation of Appifier for user'
        def sanitycheck 
          Appifier::Configuration::Checker.sanitycheck
        
        end


         # Thor method : running of Appifier setup for config rebuild [DANGER]
         desc 'reset', 'Running Appifier setup for configuration rebuild [DANGER]'
         long_desc <<-LONGDESC
         Running Appifier setup for configuration rebuild [DANGER]\n
         with --force => force collect, and destroy previous configuration [DANGER]
         LONGDESC
         option :force, type: :boolean, aliases: '-F'
         def reset
          begin 
            raise "[DANGER] please add -F if you sure : appifier configuration reset -F" unless options[:force]
            @output.warn "Appifier reset configuration" 
            Appifier::Configuration.setup force: true
            @finisher.terminate exit_case: :quiet_exit
          rescue RuntimeError => e
            @output.error e.message
            @finisher.terminate exit_case: :error_exit
          end 
         
         end

        # Thor method : Getting the current Appifier version
        desc 'version', 'Display current Appifier version'
        def version; 
          @output.info "Querying version"
          puts 'Appifier (c) Ultragreen Software'
          puts "Camille PAQUET - Romain GEORGES "
          puts TTY::Link.link_to("http://www.ultragreen.net", "http://www.ultragreen.net") 
          puts "Version #{Appifier::VERSION}"
          @finisher.terminate exit_case: :quiet_exit
        end
      end
    end
  end
end
