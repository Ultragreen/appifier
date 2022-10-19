module Appifier 
    
    module Actors
        
        module Retrivers
            class Git
                def self.get(origin:, destination:)
                    
                end
            end
            
            class Archive
                def self.get(origin:, destination:)
                    untar_gz archive: origin, destination: destination 
                end
            end
            
        end
        
        class Retriever
            
            TYPE = {:archive => Appifier::Actors::Retrivers::Archive, :git => Appifier::Actors::Retrivers::Git}
            
            def initialize(type: :archive, origin:, destination: File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH ))   
                @origin = origin
                @type  = type
                @destination = destination
                puts "retrieving template from #{origin}"
            end
            
            def get
                TYPE[@type].get origin: @origin , destination: @destination
            end
            
        end
        
    end
end