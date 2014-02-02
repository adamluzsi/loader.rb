# coding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__),"files.rb"))

### Specification for the new Gem
Gem::Specification.new do |spec|

  spec.name          = "loader"
  spec.version       = File.open(File.join(File.dirname(__FILE__),"VERSION")).read.split("\n")[0].chomp.gsub(' ','')
  spec.authors       = ["Adam Luzsi"]
  spec.email         = ["adamluzsi@gmail.com"]
  spec.description   = %q{ Require dsl, relative calls that depend on the caller methods position and stuffs like that. }
  spec.summary       = %q{Simple require dsl Based on standard CRuby}
  spec.homepage      = "https://github.com/adamluzsi/loader"
  spec.license       = "MIT"

  spec.files         = SpecFiles
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  ##=======Runtime-ENV================##
  #spec.add_runtime_dependency "asdf", ['~>4.1.3']

  ##=======Development-ENV============##
  #spec.add_development_dependency "asdf",['~>4.1.3']

end
