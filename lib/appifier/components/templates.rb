# frozen_string_literal: true

module Appifier
  module Components
    class Templates

      extend Carioca::Injector
      inject service: :output

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
