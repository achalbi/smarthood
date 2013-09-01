# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "autogrow-textarea-rails"
  s.version = "3.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Caleb Thompson"]
  s.date = "2013-04-09"
  s.description = "Rails asset pipeline around Autogrow-Textarea"
  s.email = ["cjaysson@gmail.com"]
  s.homepage = "http://www.technoreply.com/autogrow-textarea-plugin-3-0/"
  s.licenses = ["Beerware"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A jQuery plugin that allows textareas to grow vertically when text is typed in."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
