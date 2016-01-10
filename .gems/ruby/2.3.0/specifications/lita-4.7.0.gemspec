# -*- encoding: utf-8 -*-
# stub: lita 4.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "lita"
  s.version = "4.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jimmy Cuadra"]
  s.date = "2016-01-02"
  s.description = "ChatOps for Ruby."
  s.email = ["jimmy@jimmycuadra.com"]
  s.executables = ["lita"]
  s.files = ["bin/lita"]
  s.homepage = "https://github.com/jimmycuadra/lita"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.5.1"
  s.summary = "ChatOps framework for Ruby. Lita is a robot companion for your chat room."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bundler>, [">= 1.3"])
      s.add_runtime_dependency(%q<faraday>, [">= 0.8.7"])
      s.add_runtime_dependency(%q<http_router>, [">= 0.11.2"])
      s.add_runtime_dependency(%q<ice_nine>, [">= 0.11.0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0.6.9"])
      s.add_runtime_dependency(%q<multi_json>, [">= 1.7.7"])
      s.add_runtime_dependency(%q<puma>, [">= 2.7.1"])
      s.add_runtime_dependency(%q<rack>, [">= 1.5.2"])
      s.add_runtime_dependency(%q<rb-readline>, [">= 0.5.1"])
      s.add_runtime_dependency(%q<redis-namespace>, [">= 1.3.0"])
      s.add_runtime_dependency(%q<thor>, [">= 0.18.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 3.0.0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.33.0"])
    else
      s.add_dependency(%q<bundler>, [">= 1.3"])
      s.add_dependency(%q<faraday>, [">= 0.8.7"])
      s.add_dependency(%q<http_router>, [">= 0.11.2"])
      s.add_dependency(%q<ice_nine>, [">= 0.11.0"])
      s.add_dependency(%q<i18n>, [">= 0.6.9"])
      s.add_dependency(%q<multi_json>, [">= 1.7.7"])
      s.add_dependency(%q<puma>, [">= 2.7.1"])
      s.add_dependency(%q<rack>, [">= 1.5.2"])
      s.add_dependency(%q<rb-readline>, [">= 0.5.1"])
      s.add_dependency(%q<redis-namespace>, [">= 1.3.0"])
      s.add_dependency(%q<thor>, [">= 0.18.1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 3.0.0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rubocop>, ["~> 0.33.0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.3"])
    s.add_dependency(%q<faraday>, [">= 0.8.7"])
    s.add_dependency(%q<http_router>, [">= 0.11.2"])
    s.add_dependency(%q<ice_nine>, [">= 0.11.0"])
    s.add_dependency(%q<i18n>, [">= 0.6.9"])
    s.add_dependency(%q<multi_json>, [">= 1.7.7"])
    s.add_dependency(%q<puma>, [">= 2.7.1"])
    s.add_dependency(%q<rack>, [">= 1.5.2"])
    s.add_dependency(%q<rb-readline>, [">= 0.5.1"])
    s.add_dependency(%q<redis-namespace>, [">= 1.3.0"])
    s.add_dependency(%q<thor>, [">= 0.18.1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 3.0.0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rubocop>, ["~> 0.33.0"])
  end
end
