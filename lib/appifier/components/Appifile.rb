module Appifier
    module Components
        class Appifile

            attr_reader :content

            def initialize(path:)
                @path = path
                begin
                    @content = open_yaml filename: @path
                rescue RuntimeError
                    raise "Appifile missing"
                end
            end

            def dataset_rules
                @content[:template][:dataset]
            end

            def actions
                @content[:actions]
            end

            def self.validate!(path:)
                appifile = {}
                res = {status: :ok, warning: [], error: [], cleaned: []}
                begin
                    appifile = open_yaml filename: path
                rescue RuntimeError 
                    res[:error].push "Appifile missing"
                end
                return res
            end

        end
    end
end

