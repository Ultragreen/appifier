# frozen_string_literal: true

module Appifier
  module CLI
    module Subcommands
      class Templates < ::Thor
        # Thor method : list availables templates in user bundle
        desc 'ls', 'list templates availables in user bundle'
        def ls
          Appifier::Commands::Templates::list
        end

        # Thor method : remove a template from user bundle
        desc 'rm', 'rm templates from user bundle'
        def rm(template)
          Appifier::Commands::Templates::rm(template)
        end
      end
    end
  end
end
