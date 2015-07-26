# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uniform_invoice_lottery/version'

Gem::Specification.new do |spec|
  spec.name          = "uniform_invoice_lottery"
  spec.version       = UniformInvoiceLottery::VERSION
  spec.authors       = ["Yukai Huang"]
  spec.email         = ["yukaihuang1993@hotmail.com"]
  spec.summary       = %q{一個統一發票的查詢、兌獎 gem}
  spec.description   = %q{一個統一發票的查詢、兌獎 gem}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "growl"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "simplecov", "~> 0.10"

  spec.add_runtime_dependency "httpclient", "~> 2.6.0.1"
  spec.add_runtime_dependency "nokogiri", "~> 1.6"

end
