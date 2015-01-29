# coding: utf-8

# require File.expand_path(File.join(File.dirname(__FILE__),"files.rb"))

### Specification for the new Gem
Gem::Specification.new do |spec|

  spec.name          = 'loader'
  spec.version       = File.open(File.join(File.dirname(__FILE__), 'VERSION')).read.split("\n")[0].chomp.gsub(' ','')
  spec.authors       = ['Adam Luzsi']
  spec.email         = ['adamluzsi@gmail.com']
  spec.description   = %q{ easy to use File loader that allow directories/project both Lazy Load and Eager load for files and constants. The Eager load for relative directory made for gems by default }
  spec.summary       = %q{ easy to use File loader that allow directories/project both Lazy Load and Eager load for files and constants. The Eager load for relative directory made for gems by default }

  spec.homepage      = 'https://github.com/adamluzsi/loader'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']

end
