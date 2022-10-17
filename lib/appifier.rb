#require "Appifier/version"

module Appifier
  class Error < StandardError; end

  class Recurser

    def initialize(path: )
      @files = Dir.glob("#{path}/**/*").each do |file|
        p 
        File.rename file, file.gsub(/(%%.*%%)/, 'test')
      end
    end
  end


  class FoldersManager < Recurser

    def initialize(path:)

    end

  end

  class FilesManager
  end


end


test = Appifier::Recurser::new path: "/tmp/test_appifier"
pp test