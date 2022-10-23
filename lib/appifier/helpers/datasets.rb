# frozen_string_literal: true

module Appifier
    module Helpers
      module Datasets
        def open_dataset(template:)
            path = File::expand_path("#{DEFAULT_DATASETS_PATH}/#{template}.yml")
            raise 'Dataset not found' unless File::exist? path
            begin
              return YAML.load_file(path)
            rescue StandardError => e
              raise e.message
            end
        end

        def check_dataset_defined?(template:)
          return File::exist? File::expand_path("#{DEFAULT_DATASETS_PATH}/#{template}.yml")
        end

        def write_dataset(template:, data:)
          path = File::expand_path("#{DEFAULT_DATASETS_PATH}/#{template}.yml")
          File.open(path, 'w') { |file| file.write(data.to_yaml) }
        end

        def open_yaml(filename:)
          raise 'File not found' unless File::exist? filename
          begin
            return YAML.load_file(filename)
          rescue StandardError => e
            raise e.message
          end
        end

      end
    end
end