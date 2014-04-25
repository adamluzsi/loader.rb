loader
======

Ruby require loader gem with caller tricks
Meta config file loaders and much more

### Introduction

Okey, before you even think about use this gem, let's say this gem only for lazy ones...
the basic idea is to have an easy to use relative require system
The plus is a yaml config file loading mechanism for picking up yamls
into a constant,
maybe into some other config specific gem that make config objects from hash.

The fun part is , that this stuffs can be used in making a new gem,
because it do not depend on the Dir.pwd or
the File Expand tricks

The end goal is to make an easy ruby file loader for gems. So Dir.pwd do not affect

### Examples

load relative directory (not based on Dir.pwd)

```ruby

    require 'loader'

    # load all ruby file that was not loaded already
    # from that relative folder
    require_relative_directory "folder_name"

    # for recursive use try the following
    require_directory "lib", :r
    #> require_directory is an alias for require_relative_directory

    # you can use recursive by default call too
    require_directory_r "lib" #> || require_relative_directory_r

```

Additional Syntax for caller magic

```ruby

    require 'loader'

    __directory__  #> || __DIR__
    #> return the current folder where the file is

    caller_folder
    #> return the folder what called the current file/method/object

    caller_file
    #> return the file what called the current file/method/object

```