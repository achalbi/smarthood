# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "aws_cf_signer"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dylan Vaughn"]
  s.date = "2011-02-08"
  s.description = "Small gem for signing AWS CloudFront URLs given a AWS key_pair_id and pem file. Read more here: http://docs.amazonwebservices.com/AmazonCloudFront/latest/DeveloperGuide/index.html?PrivateContent.html"
  s.email = "dylan.vaughn@stlondemand.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://github.com/stlondemand/aws_cf_signer"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Ruby gem for signing AWS Cloudfront URLs for serving private content"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
