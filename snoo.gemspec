# -*- encoding: utf-8 -*-
require File.expand_path('../lib/snoo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jeff Sandberg"]
  gem.email         = ["paradox460@gmail.com"]
  gem.description   = %q{Snoo is yet another reddit API wrapper. Unlike the other wrappers out there, this one strives to be an almost exact clone of the reddit api, however, it also makes many attempts to be easier to use. You won't be instantiating Snoo::Comment or anything like that. Just one instantiation, and you can do everything from there.}
  gem.summary       = %q{A simple reddit api wrapper}
  gem.homepage      = "https://github.com/paradox460/snoo"
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "snoo"
  gem.require_paths = ["lib"]
  gem.version       = Snoo::VERSION
  gem.required_ruby_version = '>= 1.9'
  gem.license       = 'MIT'

  ['httparty', 'nokogiri'].each do |dependency|
    gem.add_runtime_dependency dependency
  end
  ['rspec'].each do |dependency|
    gem.add_development_dependency dependency
  end
end
