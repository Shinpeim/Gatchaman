# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gatchaman/version'

Gem::Specification.new do |gem|
  gem.name          = "gatchaman"
  gem.version       = Gatchaman::VERSION
  gem.authors       = ["Shinpei Maruyama"]
  gem.email         = ["shinpeim@gmail.com"]
  gem.description   = %q{Gatchaman is a gem to replace src values in HTML documents with data URI scheme}
  gem.summary       = %q{Gatchaman is a gem to replace src values in HTML documents with data URI scheme}
  gem.homepage      = "https://github.com/Shinpeim/Gatchaman"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "nokogiri", "~> 1.5.6"
  gem.add_runtime_dependency "mime-types", "~> 1.19"
  gem.add_development_dependency "rspec", "~> 2.12.0"
  gem.add_development_dependency "rake", "~> 10.0.3"
end
