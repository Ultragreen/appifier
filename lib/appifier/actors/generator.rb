
module Appifier 
    
    module Actors
        class Generator
            
            attr_reader :src_paths
            attr_reader :src_files
            attr_reader :src_folders
            attr_reader :target_folders
            attr_reader :target_files
            
            
            def initialize(src_root: , target_root:)
                @src_root = src_root
                @target_root = target_root
                @target_folders = []
                @target_files = []
                @data = {appname: 'test'}
                @src_paths = Dir.glob("#{@src_root}/**/*", File::FNM_DOTMATCH) 
                @src_paths.delete_if {|file| file =~ /\/\.$/}
                @src_folders = @src_paths.select{|item| File::directory? item }
                @src_files = @src_paths.select{|item| File::file? item }
            end
            
            
            def generate(dry_run: false, force: false )
                puts 'Running in dry_run' if dry_run
                calculate
                if check_folder_already_exist and !force
                    puts 'Folders and files already exist'
                    return false
                end
                FileUtils.rm_rf("#{@target_root}/#{@target_folders.first}") if force 
                puts 'Generate folders'
                generate_folders dry_run: dry_run
                puts 'Generate files'
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
                puts "Target path to create in #{@target_root} :"
                @target_folders.each do |path|
                    action = (dry_run)? '[SKIPPED]' : '[OK]'
                    FileUtils.mkdir_p "#{@target_root}/#{path}", noop: dry_run
                    puts "#{action} #{path}"
                end
            end
            
            def generate_files(dry_run:)
                puts "Target files to create in #{@target_root} :"
                @src_files.each_with_index do |path, index|
                    if dry_run
                        result = "[SKIPPED]"
                    else
                        begin
                            template = Template::new strict:false, 
                            list_token: @data.keys, 
                            template_file: path
                            template.map(@data)
                            content = template.output
                            File.open("#{@target_root}/#{@target_files[index]}", 'w') { |file| file.write(content) }
                            result = "[OK]"
                        rescue InvalidTokenList, NotAToken, NoTemplateFile
                            result = "[KO]"
                        end
                    end
                    puts "#{result} #{@target_files[index]}"
                end
            end
            
            
            def calculate_target(type:)
                if type == :folder then
                    target = @target_folders
                    src = @src_folders
                else
                    target = @target_files
                    src = @src_files
                end
                src.each do |folder| 
                    template = Template::new strict:false, 
                    list_token: @data.keys, 
                    template_content: folder.delete_prefix("#{@src_root}/" )
                    template.map(@data)
                    output = template.output
                    target.push output unless target.include? output
                end
                
            end
            
        end
    end
end
