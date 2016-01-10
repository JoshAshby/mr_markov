# -*- encoding: utf-8 -*-
# stub: lita-irc 2.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "lita-irc"
  s.version = "2.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.metadata = { "lita_plugin_type" => "adapter" } if s.respond_to? :metadata=
  s.require_paths = ["lib"]
  s.authors = ["Jimmy Cuadra"]
  s.date = "2015-04-19"
  s.description = "An IRC adapter for Lita."
  s.email = ["jimmy@jimmycuadra.com"]
  s.homepage = "https://github.com/jimmycuadra/lita-irc"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "An IRC adapter for the Lita chat robot."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<lita>, [">= 4.0"])
      s.add_runtime_dependency(%q<cinch>, [">= 2.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 3.0.0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
    else
      s.add_dependency(%q<lita>, [">= 4.0"])
      s.add_dependency(%q<cinch>, [">= 2.0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 3.0.0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
    end
  else
    s.add_dependency(%q<lita>, [">= 4.0"])
    s.add_dependency(%q<cinch>, [">= 2.0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 3.0.0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
  end
end
