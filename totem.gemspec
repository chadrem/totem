# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'totem/version'

Gem::Specification.new do |gem|
  gem.name          = 'totem'
  gem.version       = Totem::VERSION
  gem.authors       = ['Chad Remesch']
  gem.email         = ['chad@remesch.com']
  gem.description   = %q{Totem is a Ruby gem for creating Ruby projects.}
  gem.summary       = %q{It's like having a Rails project folder without the Rails dependency.}
  gem.homepage      = 'https://github.com/chadrem/totem'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency('bundler', '~> 1.5')
  gem.add_development_dependency('rake')
end
