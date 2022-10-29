# frozen_string_literal: true
require 'tty-markdown'
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
          begin
            Appifier::Components::Template::list
            @finisher.terminate exit_case: :quiet_exit
          rescue RuntimeError => e
            @output.error e.message
            @finisher.terminate exit_case: :error_exit
          end 
        end

        # Thor method : remove a template from user bundle
        desc 'rm TEMPLATE', 'Remove templates from user bundle'
        def rm(template)
          begin 
            Appifier::Components::Template::rm(template)
            @finisher.terminate exit_case: :quiet_exit
          rescue RuntimeError => e
            @output.error e.message
            @finisher.terminate exit_case: :error_exit
          end 
        end

        # Thor method : show information for a specific template in user bundle
        desc 'show TEMPLATE', 'show information for a specific template in user bundle'
        def show(template)
          begin
            Appifier::Components::Template::show(template)
            temp = Appifier::Components::Template::new(template: template)
            if temp.readme?
              puts " "
              puts TTY::Markdown.parse_file(temp.readme_path)
            end

            @finisher.terminate exit_case: :quiet_exit
          rescue RuntimeError => e
            @output.error e.message
            @finisher.terminate exit_case: :error_exit
          end 
        end

        # Thor method : display directory tree view for a specific template in user bundle
        desc 'treeview TEMPLATE', 'display directory tree view for a specific template in user bundle'
        def treeview(template)
          begin
            Appifier::Components::Template::treeview(template)
            @finisher.terminate exit_case: :quiet_exit
          rescue RuntimeError => e
            @output.error e.message
            @finisher.terminate exit_case: :error_exit
          end 
        end

        # Thor method : lint a specific template in user bundle
        desc 'lint TEMPLATE', 'Lint a specific template in user bundle'
        def lint(template)
          begin
            Appifier::Components::Template::lint(template)
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
