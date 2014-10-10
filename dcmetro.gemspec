# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dcmetro/version'

Gem::Specification.new do |spec|
  spec.name          = "dcmetro"
  spec.version       = Dcmetro::VERSION
  spec.authors       = ["Ken Crocken"]
  spec.email         = ["kcrocken@gmail.com"]
  spec.summary       = %q{Returns DC Metro information, including train schedules.}
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["dcmetro"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '~> 0.18'
  spec.add_dependency 'json'
  spec.add_dependency 'rest_client'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end