# frozen_string_literal: true

module Appifier
  module Configuration
    def self.setup(force: false)
      if File.exist?(File.expand_path(Appifier::DEFAULT_CONFIG_PATH)) && !force
        puts 'Appifier already configured'
      else
        FileUtils.rm_rf File.expand_path(Appifier::DEFAULT_PATH)
        config_file = search_file_in_gem('appifier', 'config/settings.yml')
        [Appifier::DEFAULT_TEMPLATES_PATH, Appifier::DEFAULT_LOGS_PATH, Appifier::DEFAULT_CONFIG_PATH, Appifier::DEFAULT_DATASETS_PATH].each do |path|
          FileUtils.mkdir_p File.expand_path(path)
        end
        File.open(File.expand_path("#{Appifier::DEFAULT_LOGS_PATH}/#{Appifier::DEFAULT_LOG_FILENAME}"), 'w') { |file| file.write("# Appifier : beginning of log file\n") }
        FileUtils.cp config_file, File.expand_path(Appifier::DEFAULT_CONFIG_PATH)
        puts '[OK] Building config folder and initialize settings'
      end
    end


    class Checker

      extend Carioca::Injector
      inject service: :output
      inject service: :finisher
       
      def self.sanitycheck
        output.info "Checking path for #{current_user} : "
        status = { true => :ok, false => :error }
        [DEFAULT_PATH,DEFAULT_TEMPLATES_PATH,DEFAULT_CONFIG_PATH,DEFAULT_LOGS_PATH,DEFAULT_DATASETS_PATH].each do |path|
          output.send status[File::exist?(File::expand_path(path))], path
        end
        output.info "Checking file for #{current_user} : "

        ["#{DEFAULT_CONFIG_PATH}/#{DEFAULT_SETTINGS_FILENAME}","#{DEFAULT_LOGS_PATH}/#{DEFAULT_LOG_FILENAME}"].each do |file|
          output.send status[File::exist?(File::expand_path(file))], file
        end
      end
    end


  end
end
