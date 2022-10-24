# frozen_string_literal: true

module Appifier
  module Components
    module Templates

      extend Carioca::Injector
      inject service: :output

      class Template

        IGNORE_LIST = [".git"]

        def initialize(template: nil, path: nil)
          raise "Missing template or path keyword" if template.nil? && path.nil?
          @path = File.expand_path("#{Appifier::DEFAULT_TEMPLATES_PATH}/#{template}") if template
          @path = path if path
          @appifile_name = "#{@path}/Appifile"
          @skeleton_path = "#{@path}/skeleton"
          @readme_path = "#{@path}/README.md"
          
        end

        def self.validate!(template: nil, path: nil)
          raise "Missing template or path keyword" if template.nil? && path.nil?
          path = File.expand_path("#{Appifier::DEFAULT_TEMPLATES_PATH}/#{template}") if template
          path = path if path
          appifile_name = "#{path}/Appifile"

          result = Appifier::Components::Appifile.validate!(path: appifile_name)
          IGNORE_LIST.each do |item|
            item_path = "#{path}/#{item}"
            if File.exist? item_path
              FileUtils::rm_rf item_path 
              result[:cleaned].push item
            end
          end
          result[:error].push "Skeleton path missing" unless File.exist?("#{path}/skeleton")
          result[:warning].push "README missing" unless File.exist?("#{path}/README.md")
          result[:status] = :ok
          result[:status] = :partial unless result[:warning].empty?
          result[:status] = :ko unless result[:error].empty?
          return result
        end
      end

      def self.list
        output.info "List of avaible templates for user : #{current_user} :"
        template_path = File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)
        Dir.glob("#{template_path}/*").map { |item| item.delete_prefix("#{template_path}/") }.each do |template|
          output.item "#{template}"
        end
      end

      def self.rm(template)
        output.info "Removing template #{template} for user : #{current_user} :"
        template_path = File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)
        begin
          if File::exist? "#{template_path}/#{template}"
            FileUtils.rm_rf "#{template_path}/#{template}"
            output.ok "Template #{template} deleted of bundle for user #{current_user}"
          else
            raise "Template #{template} not found in bundle for user #{current_user}"
          end
        rescue Errno::ENOENT
          raise "Template #{template} not found in bundle for user #{current_user}"
        end
      end
    end
  end
end
