# frozen_string_literal: true
require 'tty-tree'
module Appifier
  module Components
    
    
    class Template
      extend Carioca::Injector
      inject service: :output
      attr_accessor :appifile
      attr_reader :readme_path, :skeleton_path
      IGNORE_LIST = [".git"]
      
      def initialize(template: nil, path: nil)
        raise "Missing template or path keyword" if template.nil? && path.nil?
        @path = File.expand_path("#{Appifier::DEFAULT_TEMPLATES_PATH}/#{template}") if template
        @path = path if path
        @appifile_name = "#{@path}/Appifile"
        @skeleton_path = "#{@path}/skeleton"
        @readme_path = "#{@path}/README.md"
        begin
          @appifile = Appifier::Components::Appifile::new(path: @appifile_name)
        rescue RuntimeError
          raise "Template format error"
        end
      end

      def readme?
        File.exist? @readme_path
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
        end unless result.include? :error
        result[:error].push "Skeleton path missing" unless File.exist?("#{path}/skeleton")
        result[:warn].push "README.md missing" unless File.exist?("#{path}/README.md")
        result[:status] = :ok
        result[:status] = :partial unless result[:warn].empty?
        result[:status] = :ko unless result[:error].empty?
        return result
      end
      
      def self.list
        output.info "List of available templates for user : #{current_user} :"
        template_path = File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)
        Dir.glob("#{template_path}/*").map { |item| item.delete_prefix("#{template_path}/") }.each do |template|
          output.item "#{template}"
        end
      end
      
      def self.rm(template)
        output.info "Removing template #{template} for user : #{current_user}"
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
      
      def self.show(template)
        data = Appifier::Components::Template::new(template: template)
        data_template = data.appifile.content[:template]
        output.info "Template #{template} informations"
        output.item "Name : #{data_template[:name]}"
        output.item "Version : #{data_template[:version]}"
        if data_template[:authors]
          output.item "Authors : "
          data_template[:authors].each do |author| 
            output.arrow author
          end
        end
        output.item "Description : #{data_template[:description]}" if data_template[:description]
        output.item "Contact : #{data_template[:contact]}" if data_template[:contact]
        output.info "Dataset informations : "
        data_template[:dataset].each do |rule, definition|
          output.item "Rule : #{rule}"
          output.arrow "Description : #{definition[:description]}"
          output.arrow "Default : #{definition[:default]}" if definition[:default]
          output.arrow "Format : #{definition[:format]}"
        end

      end
      
      def self.treeview(template)
        begin
          data = Appifier::Components::Template::new(template: template)
          output.info "Getting tree view for template #{template} : "
          tree = TTY::Tree.new(data.skeleton_path)
          puts tree.render
        rescue RuntimeError
          raise "Template not found"
        end
      end

      def self.lint(template)
        begin
          res = Appifier::Components::Template.validate!(template: template)
          output.info "List of warnings for template #{template}"
          res[:warn].each do |warn|
            output.warn warn
          end
        rescue RuntimeError
          raise "Template not found"
        end
      end
    end
  end
end
