# frozen_string_literal: true


module Appifier
  module Actors
    class Collector
      
      extend Carioca::Injector
      inject service: :output
      inject service: :finisher
      
      attr_accessor :dataset
      attr_reader :template
      
      def initialize(template: ,dataset: nil,force: false )
        @force = force
        @template = template
        get_defined_dataset(dataset)
      end
    
    
      def collect
        begin         
          appifilename = "#{File.expand_path(Appifier::DEFAULT_TEMPLATES_PATH)}/#{template}/Appifile"
          appifile = Appifier::Components::Appifile::new path: appifilename
          prompt = TTY::Prompt.new
          @dataset = {
            template: template,
            data: {}
          }
          appifile.dataset_rules.each do |name, rule|
            default = (rule[:default])? rule[:default] : ""
            @dataset[:data][name] = prompt.ask("Give #{rule[:description]} : ", default: default) do |q|
              q.required true
              q.validate Regexp.new(rule[:format]) if rule[:format]
            end 
          end
          write_dataset template: @template, data: @dataset
          @collected  = true
          output.info "Dataset recorded for #{@template}" 
        rescue TTY::Reader::InputInterrupt
          output.warn "Interactive collect interrupted"
          finisher.terminate exit_case: :interrupt
        end
      end 
      
      def collected? 
        return @collected
      end
      
      private
      def get_defined_dataset(newdataset=nil)
        if check_dataset_defined? template: @template then
          @dataset = open_dataset template: @template
          if @force
            @dataset = newdataset 
            write_dataset template: @template, data: @dataset 
          else
            raise "Dataset already collect for template : #{@template}" 
          end
          @collected = true
        elsif newdataset
          @dataset = newdataset
          write_dataset template: @template, data: @dataset
          @collected  = true
        else
          @dataset = nil
          @collected  = false
        end
      end
    end
    
  end
end
