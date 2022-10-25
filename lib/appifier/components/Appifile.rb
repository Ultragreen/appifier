require 'schash'

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
                res = {status: :ok, warn: [], error: [], cleaned: []}
                begin
                    appifile = open_yaml filename: path


                rescue RuntimeError 
                    res[:error].push "Appifile missing"
                end

                validator = Schash::Validator.new do 
                    {
                        template: {
                          authors: optional(array_of(string)),
                          version: numeric,
                          contact: optional(string), 
                          description: optional(string),
                          dataset: {
                           
                          }
                        },
                        actions: {
                            deploy: {},
                            run: {}, 
                            build: {}, 
                            publish: {},
                            test: {},
                        },
                    }
                      
                  end
                result = validator.validate(appifile)
                result.each {|item| res[:error].push "Appifiler : //#{item.position.join('/')} #{item.message}"}

                return res
            end

        end
    end
end

