# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cloudinary}
  s.version = "1.0.72"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nadav Soferman", "Itai Lahan", "Tal Lev-Ami"]
  s.date = %q{2014-04-15}
  s.description = %q{Client library for easily using the Cloudinary service}
  s.email = ["nadav.soferman@cloudinary.com", "itai.lahan@cloudinary.com", "tal.levami@cloudinary.com"]
  s.homepage = %q{http://cloudinary.com}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cloudinary}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Client library for easily using the Cloudinary service}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<aws_cf_signer>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<aws_cf_signer>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<aws_cf_signer>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
