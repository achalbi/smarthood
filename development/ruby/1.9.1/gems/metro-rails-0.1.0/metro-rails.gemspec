# -*- encoding: utf-8 -*-
require File.expand_path('../lib/metro-rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Martin Schürrer"]
  gem.email         = ["martin@schuerrer.org"]
  gem.description   = %q{metroui.org.ua as a plugin for the Rails Asset Pipeline}
  gem.summary       = %q{Uses less and not sass for now.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "metro-rails"
  gem.require_paths = ["lib"]
  gem.version       = Metro::Rails::VERSION
  gem.add_runtime_dependency 'less-rails'
end
