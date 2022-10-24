# frozen_string_literal: true

module Appifier
  module CLI
    module Subcommands
      class Templates < ::Thor

        def initialize(*args)
          super
          @output = Carioca::Registry.get.get_service name: :output
          @finisher = Carioca::Registry.get.get_service name: :finisher
        end

        # Thor method : list availables templates in user bundle
        desc 'ls', 'list templates availables in user bundle'
        def ls
          Appifier::Components::Templates::list
          @finisher.terminate exit_case: :quiet_exit
        end

        # Thor method : remove a template from user bundle
        desc 'rm', 'rm templates from user bundle'
        def rm(template)
          begin 
            Appifier::Components::Templates::rm(template)
            @output.info "Template #{template} removed" 
            @finisher.terminate exit_case: :quiet_exit
          rescue RuntimeError => e
            @output.error e.message
            @finisher.terminate exit_case: :error_exit
          end 
        end
      end
    end
  end
end
