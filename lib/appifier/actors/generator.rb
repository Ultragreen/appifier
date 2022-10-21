# frozen_string_literal: true

module Appifier
  module Actors
    class Generator
      attr_reader :src_paths, :src_files, :src_folders, :target_folders, :target_files

      extend Carioca::Injector
      inject service: :output
      inject service: :terminator

      def initialize(src_root:, target_root:)
        @src_root = src_root
        @target_root = target_root
        @target_folders = []
        @target_files = []
        @data = { appname: 'test' }
        @src_paths = Dir.glob("#{@src_root}/**/*", File::FNM_DOTMATCH)
        @src_paths.delete_if { |file| file =~ %r{/\.$} }
        @src_folders = @src_paths.select { |item| File.directory? item }
        @src_files = @src_paths.select { |item| File.file? item }
        raise 'Application template not found' unless File.exist?(src_root)
      end

      def generate(dry_run: false, force: false)
        output.info 'Running in dry_run (operation will be SKIPPED)' if dry_run
        calculate
        if check_folder_already_exist && !force
          output.error 'Folders and files already exist'
          return false
        end
        FileUtils.rm_rf("#{@target_root}/#{@target_folders.first}") if force
        output.info 'Generate folders'
        generate_folders dry_run: dry_run
        output.info 'Generate files'
        generate_files dry_run: dry_run
      end

      def calculate
        calculate_target type: :folder
        calculate_target type: :file
      end

      private

      def check_folder_already_exist
        File.directory?("#{@target_root}/#{@target_folders.first}")
      end

      def generate_folders(dry_run:)
        output.info "Target path to create in #{@target_root} :"
        @target_folders.each do |path|
          action = dry_run ? :skipped : :ok
          FileUtils.mkdir_p "#{@target_root}/#{path}", noop: dry_run
          output.send action, "#{path}"
        end
      end

      def generate_files(dry_run:)
        output.info "Target files to create in #{@target_root} :"
        @src_files.each_with_index do |path, index|
          if dry_run
            result = :skipped
          else
            begin
              template = Template.new strict: false,
                                      list_token: @data.keys,
                                      template_file: path
              template.map(@data)
              content = template.output
              File.write("#{@target_root}/#{@target_files[index]}", content)
              result = :ok
            rescue InvalidTokenList, NotAToken, NoTemplateFile
              result = :ko
            end
          end
          output.send result,"#{@target_files[index]}"
        end
      end

      def calculate_target(type:)
        if type == :folder
          target = @target_folders
          src = @src_folders
        else
          target = @target_files
          src = @src_files
        end
        src.each do |folder|
          template = Template.new strict: false,
                                  list_token: @data.keys,
                                  template_content: folder.delete_prefix("#{@src_root}/")
          template.map(@data)
          output = template.output
          target.push output unless target.include? output
        end
      end
    end
  end
end
