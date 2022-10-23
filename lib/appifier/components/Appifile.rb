module Appifier
    module Components
        class Appifile

            attr_reader :content

            def initialize(path:)
                @path = path
                @content = {}
                openfile
            end

            def dataset_rules
                @content[:template][:dataset]
            end

            def actions
                @content[:actions]
            end

            private 
            def openfile
                raise 'Appifile not foud' unless File::exist? @path
                begin
                  @content = YAML.load_file(@path)
                rescue StandardError => e
                  raise e.message
                end


            end
        end
    end
end

