# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "valuable"
  s.version = "0.9.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Johnathon Wright"]
  s.date = "2013-02-15"
  s.description = "Valuable is a ruby base class that is essentially attr_accessor on steroids. A simple and intuitive interface allows you to get on with modeling in your app."
  s.email = "jw@mustmodify.com"
  s.homepage = "http://valuable.mustmodify.com/"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.28"
  s.summary = "attr_accessor on steroids with defaults, attribute formatting, alias methods, etc."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
