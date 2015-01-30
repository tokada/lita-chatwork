# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lita/chatwork/version'

Gem::Specification.new do |spec|
  spec.name          = "lita-chatwork"
  spec.version       = Lita::Chatwork::VERSION
  spec.authors       = ["tokada"]
  spec.email         = ["ubiqnet@gmail.com"]
  spec.description   = %q{A ChatWork adapter for Lita.}
  spec.summary       = %q{A ChatWork adapter for Lita.}
  spec.homepage      = "https://github.com/tokada/lita-chatwork"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.1"
  spec.add_runtime_dependency "chatwork", ">= 0.1.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
