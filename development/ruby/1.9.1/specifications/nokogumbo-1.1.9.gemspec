# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nokogumbo"
  s.version = "1.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Ruby"]
  s.date = "2014-06-11"
  s.description = "Nokogumbo allows a Ruby program to invoke the Gumbo HTML5 parser and access the result as a Nokogiri parsed document."
  s.email = "rubys@intertwingly.net"
  s.extensions = ["ext/nokogumboc/extconf.rb"]
  s.files = ["ext/nokogumboc/extconf.rb"]
  s.homepage = "https://github.com/rubys/nokogumbo/#readme"
  s.licenses = ["Apache 2.0"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.28"
  s.summary = "Nokogiri interface to the Gumbo HTML5 parser"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
