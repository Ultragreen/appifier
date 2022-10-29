# frozen_string_literal: true
module Appifier
  module CLI
    module Subcommands
      class Datasets < ::Thor

        def initialize(*args)
            super
            @output = Carioca::Registry.get.get_service name: :output
            @finisher = Carioca::Registry.get.get_service name: :finisher
          end
  
          # Thor method : list availables datasets in user bundle
          desc 'ls', 'list defined datasets in user bundle'
          def ls
            Appifier::Components::Dataset::list
            @finisher.terminate exit_case: :quiet_exit
          end


          # Thor method : Prune orphans datasets in user bundle
          desc 'ls', 'Prune orphans datasets in user bundle'
          long_desc <<-LONGDESC
            Prune orphans datasets in user bundle\n
            with --force, force pruning of dataset [DANGER]
          LONGDESC
          option :force, type: :boolean, aliases: '-F'
          def prune
            begin
                ok = (options[:force]) ?  true : TTY::Prompt.new.yes?("Do you want to prune datasets?")
                if ok
                    Appifier::Components::Dataset::prune
                    @finisher.terminate exit_case: :quiet_exit
                else
                    puts "Pruning cancelled"
                    @finisher.terminate exit_case: :quiet_exit
                end
            rescue TTY::Reader::InputInterrupt
                @output.warn "Command interrupted"
                @finisher.terminate exit_case: :interrupt
            end   
          end
        end
      end
    end
end