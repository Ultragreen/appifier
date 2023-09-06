module Appifier
    module Components
        class Dataset

            extend Carioca::Injector
            inject service: :output

            def self.list
                output.info "List of available Datasets for user : #{current_user} :"
                templates_path = File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)
                datasets_path = File.expand_path(Appifier::DEFAULT_DATASETS_PATH)
                templates = Dir.glob("#{templates_path}/*").map { |item| item.delete_prefix("#{templates_path}/") }
                Dir.glob("#{datasets_path}/*").map { |item| item.delete_prefix("#{datasets_path}/") }.each do |file|
                    dataset = File::basename(file,'.yml')
                    res = dataset; res << " [TEMPLATE MISSING]" unless templates.include? dataset 
                    output.item res
                end
            end


            def self.prune
                output.info "Pruning Datasets for user : #{current_user} :"
                templates_path = File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)
                datasets_path = File.expand_path(Appifier::DEFAULT_DATASETS_PATH)
                templates = Dir.glob("#{templates_path}/*").map { |item| item.delete_prefix("#{templates_path}/") }
                Dir.glob("#{datasets_path}/*").each do |file|
                    dataset = File::basename(file,'.yml')
                    unless templates.include? dataset 
                        FileUtils::rm file 
                        output.item "Pruned : #{dataset}"
                    end
                end
            end


            def self.show(dataset)
                output.info "Dataset #{dataset} informations"
                dataset_path = File.expand_path(Appifier::DEFAULT_DATASETS_PATH)
                begin
                if File::exist? "#{dataset_path}/#{dataset}.yml"
                    File.open("#{dataset_path}/#{dataset}.yml", 'r') do |file|
                        file.each_line do |line|
                        output.item line
                        end
                    end
                else
                    raise "Dataset #{dataset} not found in bundle for user #{current_user}"
                end
                rescue Errno::ENOENT
                    raise "Dataset #{dataset} not found in bundle for user #{current_user}"
                end
            end

            def self.rm(dataset)
                output.info "Removing dataset #{dataset} for user : #{current_user}"
                dataset_path = File.expand_path(Appifier::DEFAULT_DATASETS_PATH)
                begin
                if File::exist? "#{dataset_path}/#{dataset}.yml"
                    FileUtils.rm_rf "#{dataset_path}/#{dataset}.yml"
                    output.ok "Dataset #{dataset} deleted of bundle for user #{current_user}"
                else
                    raise "Dataset #{dataset} not found in bundle for user #{current_user}"
                end
                rescue Errno::ENOENT
                    raise "Dataset #{dataset} not found in bundle for user #{current_user}"
                end
            end

            def self.update(dataset)
                output.info "Updating dataset #{dataset}"
                dataset_path = File.expand_path(Appifier::DEFAULT_DATASETS_PATH)
                appifilename = "#{File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)}/#{dataset}/Appifile"
                if File::exist? "#{dataset_path}/#{dataset}.yml"
                    appifile = Appifier::Components::Appifile::new path: appifilename
                    begin
                        prompt = TTY::Prompt.new
                        terminate = false
                        while terminate === false
                            selected_value = prompt.select("What do you want to update ? ", appifile.dataset_rules.keys.push('terminate'))
                            if selected_value == 'terminate'
                                terminate = true
                                output.ok "Dataset #{dataset} updated"
                            else
                                dataset_file_content = YAML.load_file("#{dataset_path}/#{dataset}.yml")
                                data = dataset_file_content
                                rule = appifile.dataset_rules.fetch(selected_value)
                                data[:data][selected_value] = prompt.ask("Give #{rule[:description]} : ", default: dataset_file_content[selected_value]) do |q|
                                    q.required true
                                    q.validate Regexp.new(rule[:format]) if rule[:format]
                                end 
                                write_dataset template: dataset, data: data
                            end
                        end

                    rescue Errno::ENOENT
                        raise "Dataset #{dataset} not found in bundle"
                    end
                else
                    raise "Dataset #{dataset} not found in bundle"
                end
            end

            def self.edit(dataset)
                output.info "Edit dataset #{dataset}"
                dataset_path = File.expand_path(Appifier::DEFAULT_DATASETS_PATH)
                appifilename = "#{File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)}/#{dataset}/Appifile"
                if File::exist? "#{dataset_path}/#{dataset}.yml"
                    editor_command = ENV['EDITOR'] || "vim"
                    if editor_command.nil? || editor_command.empty?
                    puts "The $EDITOR environment variable is not set."
                    else
                    pid = Process.fork do
                        if !system("#{editor_command} #{dataset_path}/#{dataset}.yml")
                            output.error "Editor #{editor_command} not found. You can set up the EDITOR environment variable and retry the command."
                        else 
                            output.ok "Update dataset #{dataset} done"
                        end
                    end
                    Process.wait(pid) if pid
                    end
                else
                    raise "Dataset #{dataset} not found in bundle"
                end
            end
        end
    end
end