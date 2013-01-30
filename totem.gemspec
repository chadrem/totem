# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'totem/version'

Gem::Specification.new do |gem|
  gem.name          = "totem"
  gem.version       = Totem::VERSION
  gem.authors       = ["Chad Remesch"]
  gem.email         = ["chad@remesch.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('tribe', '0.0.8')
  gem.add_dependency('tribe_em', '0.0.2')
end
