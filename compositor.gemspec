# -*- encoding: utf-8 -*-
require File.expand_path('../lib/compositor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Konstantin Gredeskoul","Paul Henry"]
  gem.email         = %w(kigster@gmail.com  paul@wanelo.com)
  gem.description   = %q{Composite design pattern with a convenient DSL for building JSON/Hashes of complex objects}
  gem.summary       = %q{Composite design pattern with a convenient DSL for building JSON/Hashes of complex objects}
  gem.homepage      = "https://github.com/wanelo/compositor"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "compositor"
  gem.require_paths = %w(lib)
  gem.version       = Compositor::VERSION

  gem.add_development_dependency 'rspec'

  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-fsevent'
end
