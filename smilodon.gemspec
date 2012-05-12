# -*- encoding: utf-8 -*-
require File.expand_path('../lib/smilodon/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = [ 'Umang Chouhan', 'Hubert Huang', 'Atsuya Takagi' ]
  gem.email         = [ 'uchouhan@optimiscorp.com' ]
  gem.description   = 'Smilodon is a utility to parse data files.'
  gem.summary       = 'Smilodon is a utility to parse data files.'
  gem.homepage      = 'http://github.com/optimis/smilodon'

  gem.files         = `git ls-files`.split($\)

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.name          = 'smilodon'
  gem.require_paths = [ 'lib', 'lib/smilodon' ]
  gem.version       = Smilodon::VERSION
end
