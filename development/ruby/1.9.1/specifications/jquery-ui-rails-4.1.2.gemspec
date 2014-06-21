# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jquery-ui-rails}
  s.version = "4.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jo Liss"]
  s.date = %q{2014-02-18}
  s.description = %q{jQuery UI's JavaScript, CSS, and image files packaged for the Rails 3.1+ asset pipeline}
  s.email = ["joliss42@gmail.com"]
  s.homepage = %q{https://github.com/joliss/jquery-ui-rails}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{jQuery UI packaged for the Rails asset pipeline}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1.0"])
      s.add_development_dependency(%q<json>, ["~> 1.7"])
    else
      s.add_dependency(%q<railties>, [">= 3.1.0"])
      s.add_dependency(%q<json>, ["~> 1.7"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1.0"])
    s.add_dependency(%q<json>, ["~> 1.7"])
  end
end
