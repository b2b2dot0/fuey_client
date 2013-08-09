# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuey_client/version'

Gem::Specification.new do |spec|
  spec.name          = "fuey_client"
  spec.version       = FueyClient::VERSION
  spec.authors       = ["Matt Snyder"]
  spec.email         = ["snyder2112@me.com"]
  spec.description   = %q{Client for inspecting server state and reports it back to Fuey}
  spec.summary       = %q{Client for inspecting server state and reports it back to Fuey. Requires the Fuey web app to have any value.}
  spec.homepage      = "http://github.com/b2b2dot0/fuey_client"
  spec.licenses      = ["MIT", "GPL-2"]

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.default_executable = "fuey"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "configurethis", ">= 1.0.4"
  spec.add_dependency "net-ping", "~> 1.6"
  spec.add_dependency "sapnwrfc", "~> 0.26"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-given", ">= 3.0.0"
end
