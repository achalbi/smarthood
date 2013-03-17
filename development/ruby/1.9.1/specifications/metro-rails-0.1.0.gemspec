# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "metro-rails"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Schu\u{308}rrer"]
  s.date = "2012-06-07"
  s.description = "metroui.org.ua as a plugin for the Rails Asset Pipeline"
  s.email = ["martin@schuerrer.org"]
  s.homepage = ""
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Uses less and not sass for now."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<less-rails>, [">= 0"])
    else
      s.add_dependency(%q<less-rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<less-rails>, [">= 0"])
  end
end
