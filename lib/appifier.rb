# frozen_string_literal: true

require 'carioca'
require 'thot'
require 'fileutils'
require 'etc'

include Thot
module Appifier
  DEFAULT_PATH = '~/.appifier'
  DEFAULT_TEMPLATES_PATH = "#{DEFAULT_PATH}/templates"
  DEFAULT_CONFIG_PATH = "#{DEFAULT_PATH}/settings.yml"
end

require 'appifier/version'
require 'appifier/helpers/init'

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
  spec.init_from_file = false
  spec.debug = true if ENV['DEBUG']
  spec.log_file = '/tmp/appifier.log'
  spec.config_file = './config/settings.yml'
  spec.config_root = :appifier
  spec.environment = :production
  spec.default_locale = :fr
  spec.locales_load_path << Dir["#{File.expand_path('./config/locales')}/*.yml"]
end

module Appifier
  class Application < Carioca::Container
    inject service: :configuration
    inject service: :i18n
    logger.info(to_s) { 'Running Appifier' }
  end
end
