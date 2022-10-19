# frozen_string_literal: true

module Appifier
  module CLI
    module Subcommands
      class Configuration < ::Thor
        # Thor method : running of Appifier sanitycheck
        desc 'sanitycheck', 'Verify installation of Appifier for user'
        def sanitycheck; end

        # Thor method : Getting the current Appifier version
        desc 'version', 'Display current Appifier version'
        def version; end
      end
    end
  end
end
