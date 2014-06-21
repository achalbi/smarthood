# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{aws_cf_signer}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dylan Vaughn"]
  s.date = %q{2014-05-26}
  s.email = ["dylancvaughn@gmail.com"]
  s.homepage = %q{https://github.com/dylanvaughn/aws_cf_signer}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Ruby gem for signing AWS Cloudfront URLs for serving private content.}

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<thoughtbot-shoulda>, ["~> 2.11"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
    else
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<thoughtbot-shoulda>, ["~> 2.11"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<thoughtbot-shoulda>, ["~> 2.11"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
  end
end
