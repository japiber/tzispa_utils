# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require File.expand_path('../lib/tzispa/utils/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name        = Tzispa::Utils::GEM_NAME
  spec.version     = Tzispa::Utils::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Juan Antonio Piñero']
  spec.email       = ['japinero@area-integral.com']
  spec.homepage    = 'https://github.com/japiber/tzispa_utilspec.git'
  spec.summary     = 'Utilities for Tzispa'
  spec.description = 'Utility classes used by Tzispa framework'
  spec.licenses    = ['MIT']

  spec.required_ruby_version = '~> 2.3'

  spec.add_dependency 'i18n',         '~> 0.8'
  spec.add_dependency 'sanitize',     '~> 4.4'
  spec.add_dependency 'escape_utils', '~> 1.2'
  spec.add_dependency 'mail',         '~> 2.6'

  spec.add_development_dependency 'minitest', '~> 5.0'

  spec.files         = Dir['{lib}/**/*', '{test}/**/*'] +
                       %w(README.md CHANGELOG.md LICENSE Rakefile)
  spec.require_paths = %w(lib test)
end
