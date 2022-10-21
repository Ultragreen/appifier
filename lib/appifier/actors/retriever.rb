# frozen_string_literal: false

module Appifier
  module Actors
    module Retrivers
      class Git
        def self.get(origin:, destination:); 
          raise 'not yest implemented'
        end
      end

      class Archive
        def self.get(origin:, destination:)
          raise "Archive : #{origin} not found" unless File::exist? origin
          untar_gz archive: origin, destination: destination
        end
      end
    end

    class Retriever
      extend Carioca::Injector
      inject service: :output

      TYPE = { archive: Appifier::Actors::Retrivers::Archive, git: Appifier::Actors::Retrivers::Git }

      def initialize(origin:, type: :archive, destination: File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH))
        @origin = origin
        @type = type
        @destination = destination
        output.info "retrieving template from #{origin}"
      end

      def get
        TYPE[@type].get origin: @origin, destination: @destination
      end
    end
  end
end
