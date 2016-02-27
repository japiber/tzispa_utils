# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tzispa/utils/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = Tzispa::Utils::GEM_NAME
  s.version     = Tzispa::Utils::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Juan Antonio Piñero']
  s.email       = ['japinero@area-integral.com']
  s.homepage    = 'https://github.com/japiber/tzispa_utils.git'
  s.summary     = 'Utilities for Tzispa'
  s.description = 'Utilities for Tzispa'
  s.licenses    = ['MIT']

  s.required_ruby_version     = '~> 2.3'

  s.files         = Dir.glob("{lib}/**/*") + %w(README.md CHANGELOG.md)
  s.require_paths = ['lib']
end
