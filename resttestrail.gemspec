# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resttestrail/version'

Gem::Specification.new do |spec|
  spec.name          = "resttestrail"
  spec.version       = Resttestrail::VERSION
  spec.authors       = ["Syed Hussain"]
  spec.email         = ["shussain@groupon.com"]
  spec.summary       = %q{Gem for Testrail rest api}
  spec.description   = %q{Resttestrail is a ruby gem for the TestRail API (v2) which is available with TestRail 3.0 and later.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '~> 3.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
