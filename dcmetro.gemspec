
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dcmetro/version'

Gem::Specification.new do |spec|
  spec.name          = 'dcmetro'
  spec.version       = Dcmetro::VERSION
  spec.authors       = ['Ken Crocken']
  spec.email         = ['kcrocken@gmail.com']
  spec.summary       = 'Returns DC Metro Rails information, including train schedules.'
  spec.description   = 'Washington, DC Metro Rails information, including lines, stations and arrival/departure predictions.'
  spec.homepage      = 'https://github.com/kencrocken/dcmetro'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['dcmetro']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.18'
  spec.add_dependency 'json'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-cucumber'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'

  # spec.metadata["yard.run"] = "yri" # use "yard" to build full HTML docs.

end
