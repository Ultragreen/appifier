module Appifier
  class Configuration
    def self.setup(force: false)
      
      if File::exist? File.expand_path(Appifier::DEFAULT_CONFIG_PATH) and !force
        puts 'Appifier already configured' 
      else
        config_file = search_file_in_gem('appifier','config/settings.yml')
        path = File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)
        FileUtils::mkdir_p File.expand_path(path) unless File::exist? File.expand_path(path)
        FileUtils::cp config_file, File.expand_path(Appifier::DEFAULT_PATH)
        puts '[OK] Building config folder and initialize settings'
      end
    end
  end
end