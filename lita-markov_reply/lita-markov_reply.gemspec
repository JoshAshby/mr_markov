Gem::Specification.new do |spec|
  spec.name          = "lita-markov_reply"
  spec.version       = "0.1.0"
  spec.authors       = ["JoshAshby"]
  spec.email         = ["joshuaashby@joshashby.com"]
  spec.description   = ""
  spec.summary       = ""
  spec.homepage      = ""
  spec.license       = ""

  spec.required_ruby_version = '>= 2.3.0'

  if spec.respond_to? :metadata
    spec.metadata      = { "lita_plugin_type" => "handler" }
  end

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
