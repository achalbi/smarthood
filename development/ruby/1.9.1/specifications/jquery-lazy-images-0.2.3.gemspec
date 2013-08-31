# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jquery-lazy-images"
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Singlebrook Technology"]
  s.date = "2013-03-27"
  s.description = "Why make the browser load images that the user isn't going to see?\n    This Rails engine prevents images from loading until they're actually going to be displayed.\n    This saves bandwidth, reduces server load, and helps the user stay under their data quota."
  s.email = ["leon@singlebrook.com"]
  s.homepage = "https://github.com/singlebrook/jquery-lazy-images"
  s.post_install_message = "If you use image_tag in your email templates, please change it to\n    eager_image_tag. If you don't, your email messages WILL LOOK WRONG!\n    This DANGEROUS command might make those changes for you:\n      sed -i 's/image_tag/eager_image_tag/g' app/views/*_mailer/*\n    "
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Load all images in your Rails app lazily (i.e. only when they are visible)."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.1"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<guard-spork>, [">= 0"])
      s.add_development_dependency(%q<poltergeist>, [">= 0"])
      s.add_development_dependency(%q<rb-fsevent>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.1"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<guard-spork>, [">= 0"])
      s.add_dependency(%q<poltergeist>, [">= 0"])
      s.add_dependency(%q<rb-fsevent>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.1"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<guard-spork>, [">= 0"])
    s.add_dependency(%q<poltergeist>, [">= 0"])
    s.add_dependency(%q<rb-fsevent>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
  end
end
