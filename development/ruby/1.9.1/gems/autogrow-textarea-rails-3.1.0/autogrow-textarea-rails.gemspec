# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autogrow-textarea/version'

Gem::Specification.new do |spec|
  spec.name          = "autogrow-textarea-rails"
  spec.version       = AutogrowTextarea::VERSION
  spec.authors       = ["Caleb Thompson"]
  spec.email         = ["cjaysson@gmail.com"]
  spec.summary       = "A jQuery plugin that allows textareas to grow vertically when text is typed in."
  spec.description   = "Rails asset pipeline around Autogrow-Textarea"
  spec.homepage      = "http://www.technoreply.com/autogrow-textarea-plugin-3-0/"
  spec.license       = "Beerware"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
