# frozen_string_literal: false
require 'git'
require 'uri'
module Appifier
  module Actors
    module Retrivers
      class Git
        def self.get(origin:, destination:)
          uri = URI.parse(origin)
          path = uri.path
          name = File.basename(path, ".git") 
          raise "Git URL format failed (only http bare git format)" if name.include?('.')
          ::Git.clone(origin, nil, path: destination)
          return name
        end
      end

      class Archive
        def self.get(origin:, destination:)
          raise "Archive : #{origin} not found" unless File::exist? origin
          name = File.basename(origin, ".tgz") 
          raise "Template name format failed : must be .tgz file" if name.include?('.')
          untar_gz archive: origin, destination: destination
          return name
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
        output.info "Retrieving template from #{origin}"
      end

      def get
        template = TYPE[@type].get origin: @origin, destination: @destination
        result = Appifier::Components::Template.validate!(template: template)
        unless result[:error].empty?
          output.ko "Template #{template} retrieving cancelled" 
          Appifier::Components::Template.rm(template) unless result[:error].empty?

        end 
        return result
      end
    end
  end
end
