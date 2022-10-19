# frozen_string_literal: true

module Appifier
  module Helpers
    module Templates
      def list_bundled_templates
        template_path = File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)
        Dir.glob("#{template_path}/*").map { |item| item.delete_prefix("#{template_path}/") }.each do |template|
          puts " * #{template}"
        end
      end

      def rm_bundled_template(template)
        template_path = File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)
        begin
          if FileUtils.rm_rf "#{template_path}/#{template}"
            puts "[RM] Template #{template} deleted of bundle for user #{current_user}"
          else
            puts "[ERROR] Template #{template} not found in bundle for user #{current_user}"
          end
        rescue Errno::ENOENT
          puts "[ERROR] Template #{template} not found in bundle for user #{current_user}"
        end
      end
    end
  end
end
