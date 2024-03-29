# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'appifier'
  spec.version       = `cat VERSION`.chomp
  spec.authors       = ['Camille Paquet', 'Romain GEORGES']
  spec.email         = ['gems@ultragreen.net']

  spec.summary       = 'Appifier : Applications templating and management tools '
  spec.description   = 'Appifier : Applications templating and management tools '
  spec.homepage      = 'https://github.com/Ultragreen/appifier'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'code_statistics', '~> 0.2.13'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'roodi', '~> 5.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.32'
  spec.add_development_dependency 'version', '~> 1.1'
  spec.add_development_dependency 'yard', '~> 0.9.27'
  spec.add_development_dependency 'yard-rspec', '~> 0.1'
  spec.metadata['rubygems_mfa_required'] = 'false'
  spec.add_dependency 'carioca', '~> 2.1'
  spec.add_dependency 'thor', '~> 1.2'
  spec.add_dependency 'tty-prompt', '~> 0.23.1'
  spec.add_dependency "thot", "~> 1.2.1"
  spec.add_dependency "git", "~> 1.12"
  spec.add_dependency "schash","~> 0.1.2"
  spec.add_dependency "tty-tree", "~> 0.4.0"
  spec.add_dependency "tty-markdown", "~> 0.7.0"
  spec.add_dependency "tty-link", "~> 0.1.1"
end
