# frozen_string_literal: true

module Appifier
  class Configuration
    def self.setup(force: false)
      if File.exist?(File.expand_path(Appifier::DEFAULT_CONFIG_PATH)) && !force
        puts 'Appifier already configured'
      else
        config_file = search_file_in_gem('appifier', 'config/settings.yml')
        [Appifier::DEFAULT_TEMPLATES_PATH, Appifier::DEFAULT_LOGS_PATH, Appifier::DEFAULT_CONFIG_PATH, Appifier::DEFAULT_DATASETS_PATH].each do |path|
          FileUtils.mkdir_p File.expand_path(path)
        end
        File.open(File.expand_path("#{Appifier::DEFAULT_LOGS_PATH}/#{Appifier::DEFAULT_LOG_FILENAME}"), 'w') { |file| file.write("# Appifier : beginning of log file\n") }
        FileUtils.cp config_file, File.expand_path(Appifier::DEFAULT_CONFIG_PATH)
        puts '[OK] Building config folder and initialize settings'
      end
    end
  end
end
