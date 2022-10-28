# frozen_string_literal: true

require 'carioca'
require 'thot'
require 'fileutils'
require 'etc'


require 'thor'
require "tty-prompt"
require 'tty-link'

include Thot


require 'appifier/version'
require 'appifier/helpers/init'

module Appifier
  DEFAULT_PATH = '~/.appifier'
  DEFAULT_TEMPLATES_PATH = "#{DEFAULT_PATH}/templates"
  DEFAULT_CONFIG_PATH = "#{DEFAULT_PATH}/config"
  DEFAULT_LOGS_PATH = "#{DEFAULT_PATH}/logs" 
  DEFAULT_DATASETS_PATH = "#{DEFAULT_PATH}/datasets"
  DEFAULT_LOG_FILENAME = "appifier.log"
  DEFAULT_SETTINGS_FILENAME = "settings.yml"
  DEFAULT_REGISTRY  = "config/appifier.registry"
end

Appifier::Helpers.constants.select { |c| Appifier::Helpers.const_get(c).is_a? Module }
                 .map { |item| item = "Appifier::Helpers::#{item}" }
                 .each { |mod| include Object.const_get(mod) }


require 'appifier/setup'
require 'appifier/actors/init'

unless File.exist? File.expand_path(Appifier::DEFAULT_CONFIG_PATH)
  puts "[W] Appifier not initialized for user #{current_user}, running setup"
  Appifier::Configuration.setup
end

Carioca::Registry.configure do |spec|
  spec.filename = "#{search_file_in_gem('appifier', Appifier::DEFAULT_REGISTRY )}"
  spec.init_from_file = true
  spec.debug = true if ENV['DEBUG']
  spec.log_file = File.expand_path("#{Appifier::DEFAULT_LOGS_PATH}/#{Appifier::DEFAULT_LOG_FILENAME}")
  spec.config_file = File.expand_path("#{Appifier::DEFAULT_CONFIG_PATH}/#{Appifier::DEFAULT_SETTINGS_FILENAME}")
  spec.config_root = :appifier
  spec.environment = :production
  spec.output_mode = :dual
  spec.output_emoji = true
  spec.output_colors = true
end

require_relative 'appifier/services/init'
require_relative 'appifier/components/init'