# frozen_string_literal: true

module Appifier
  module CLI
    module Subcommands
      class Templates < ::Thor
        # Thor method : list availables templates in user bundle
        desc 'ls', 'list templates availables in user bundle'
        def ls
          puts "List of avaible templates for user : #{current_user} :"
          list_bundled_templates
        end

        # Thor method : remove a template from user bundle
        desc 'rm', 'rm templates from user bundle'
        def rm(template)
          puts "Removing template #{template} for user : #{current_user} :"
          rm_bundled_template(template)
        end
      end
    end
  end
end
