# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anonymize/version'

Gem::Specification.new do |spec|
  spec.name          = "anonymize"
  spec.version       = Anonymize::VERSION
  spec.authors       = ["Andrew Fecheyr"]
  spec.email         = ["andrew@bedesign.be"]
  spec.description   = %q{Anonymize database data on the fly}
  spec.summary       = %q{Anonymize database data}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
