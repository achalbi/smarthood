# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "macbury-metro-ui-rails"
  s.version = "0.15.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Vilius Luneckas"]
  s.date = "2013-01-09"
  s.description = "metro-ui-rails project integrates Metro-UI CSS toolkit for Rails 3.1 Asset Pipeline"
  s.email = ["vilius.luneckas@gmail.com"]
  s.homepage = "https://github.com/viliusluneckas/metro-ui-rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Metro-UI CSS toolkit for Rails 3.1 Asset Pipeline"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<less-rails>, ["~> 2.2.3"])
      s.add_development_dependency(%q<rails>, [">= 3.1"])
    else
      s.add_dependency(%q<less-rails>, ["~> 2.2.3"])
      s.add_dependency(%q<rails>, [">= 3.1"])
    end
  else
    s.add_dependency(%q<less-rails>, ["~> 2.2.3"])
    s.add_dependency(%q<rails>, [">= 3.1"])
  end
end
