#require "Appifier/version"


require 'thot'
require 'fileutils'

include Thot
module Appifier
  class Error < StandardError; end

  class Generator

      attr_reader :src_paths
      attr_reader :src_files
      attr_reader :src_folders

      attr_reader :target_folders
      attr_reader :target_files


    def initialize(src_root: , target_root:)

      @src_root = src_root
      @target_root = target_root

      @data = {appname: 'test'}

      @src_paths = Dir.glob("#{@src_root}/**/*", File::FNM_DOTMATCH) 
      @src_paths.delete_if {|file| file =~ /\/\.$/}
      @src_folders = @src_paths.select{|item| File::directory? item }
      @src_files = @src_paths.select{|item| File::file? item }

    end


    def generate(dry_run: false )
      puts 'Running in dry_run' if dry_run
      calculate
      generate_folders dry_run: dry_run
  
    end

    def calculate
      calculate_folders
    end

    private

    def generate_folders(dry_run:)
      puts "Target path to create in #{@target_root} :"
      @target_folders.each do |path|
        action = (dry_run)? '[skipped]' : '[OK]'
        FileUtils.mkdir_p "#{@target_root}/#{path}", noop: dry_run
        puts "#{action} #{path}"
      end
    end


    def calculate_folders
      @target_folders = []
      @src_folders.each do |folder| 
        template = Template::new strict:false, 
          list_token: @data.keys, 
          template_content: folder.delete_prefix("#{@src_root}/" )
        template.map(@data)
        @target_folders.push template.output
      end
    end

  end


   


end


test = Appifier::Generator::new src_root: "/tmp/appifier/skeleton", target_root: "/tmp/appifier"
test.generate

