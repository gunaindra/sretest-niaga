# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'source_install'

Gem::Specification.new do |spec|
  spec.name = 'source_install'
  spec.version = Source::Install::VERSION
  spec.authors = ['UA OIT Systems Engineering']
  spec.email = ['ua-oit-se@alaska.edu']
  spec.description =
    'Common logic for downloading, configuring, compiling, and installing packages from source. '\
    'Auto-magically included in Chef by depending on the source_install cookbook. '\
    'Used/tested in first-party cookbooks openssl_install, sqlite_install, and python_install. '\
    'This gem uses Chef resources internally, so can be used only within a Chef cookbook.'
  spec.summary = 'Common logic for installing from source.'
  spec.homepage = 'https://github.com/ualaska-it/source_install'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.4.0' # rubocop:disable Gemspec/RequiredRubyVersion

  spec.files = [
    'LICENSE',
    'lib/source_install.rb'
  ]
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'chefspec'
  spec.add_development_dependency 'kitchen-vagrant'
  spec.add_development_dependency 'test-kitchen'
end
