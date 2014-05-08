loader
======

Ruby module for file lifting :)

### Introduction

Okey, before you even think about use this gem,
let's say this gem only for lazy ones...
the basic idea is to have an easy to use relative require system
The plus is a yaml config file loading mechanism for picking up yamls
into a constant,
maybe into some other config specific gem that make config objects from hash.

The fun part is , that this stuffs can be used in gems (modules),
because it do not depend on the Dir.pwd or any kind of absolute path or
the File expand_path tricks that based on the application position.

The end goal is to make an easy ruby file loader for gems. So Dir.pwd do not affect

### Examples

load relative directory (not based on Dir.pwd but the caller files position)
if you pass multiple string as argument it will be joined by file separator that the OS use

```ruby

    require 'loader'

    # load all ruby file that was not loaded already
    # from that relative folder
    require_relative_directory "folder_name"

    # for recursive use try the following
    require_relative_directory "lib", :r

    # or
    require_relative_directory_r "lib"

    # or
    require_relative_directory "lib",r: true

```

Additional Syntax for caller magics

```ruby

    require 'loader'

    __directory__  #> || __DIR__
    #> return the current folder where the file is

    caller_folder
    #> return the folder what called the current file/method/object

    caller_file
    #> return the file what called the current file/method/object

```