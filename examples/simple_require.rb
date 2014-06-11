require_relative "../lib/loader"

#> require the ruby files from lib
require_directory "lib", ex: "hello.rb"

#> require the ruby files from and under to lib (recursive)
require_directory_r "lib", ex: "hello.rb"
