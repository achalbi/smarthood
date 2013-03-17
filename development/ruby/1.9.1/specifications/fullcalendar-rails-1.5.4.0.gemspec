# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "fullcalendar-rails"
  s.version = "1.5.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["bokmann"]
  s.date = "2012-10-13"
  s.description = "FullCalendar is a fantastic jquery plugin that gives you an event calendar with tons of great ajax wizardry, incluing drag and drop of events.  I like having managed pipeline assets, so I gemified it."
  s.email = ["dbock@codesherpas.com"]
  s.homepage = "https://github.com/bokmann/fullcalendar-rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A simple asset pipeline bundling of the fullcalendar jquery plugin."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
