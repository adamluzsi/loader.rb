require_relative "../lib/loader"

puts Loader.meta "examples","lib","**","meta"
#> {"asdf"=>{"else"=>{"world"=>"hello"}, "stuff"=>{"hello"=>"world"}}}

puts Loader.meta root: File.expand_path(File.dirname(__FILE__))
#> {"asdf"=>{"else"=>{"world"=>"hello"}, "stuff"=>{"hello"=>"world"}}}


puts Loader.meta  "lib","**","meta",
                  root: File.expand_path(File.dirname(__FILE__))
#> {"asdf"=>{"else"=>{"world"=>"hello"}, "stuff"=>{"hello"=>"world"}}}

puts Loader.meta absolute: File.expand_path(File.join(File.dirname(__FILE__),"lib","**","meta"))
#> {"asdf"=>{"else"=>{"world"=>"hello"}, "stuff"=>{"hello"=>"world"}}}

puts Loader.metaloader_framework root: File.expand_path(File.dirname(__FILE__))
#> {"asdf"=>{"else"=>{"world"=>"hello"}, "stuff"=>{"hello"=>"world"}}}