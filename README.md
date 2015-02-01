loader
======

Ruby module for Easy File lifting :)

### Introduction

Okey, before you even think about use this gem,
let's say this gem only for lazy ones...

the basic idea is to have an easy to use relative require system and a namespace based Constant loading logic

The fun part is , that this stuffs can be used in gems (modules),
because it do not depend on the Dir.pwd or any kind of absolute path or
the File expand_path tricks that based on the application position.

The end goal is to make an easy ruby file loader for apps and gems.

### Examples

load relative directory (not based on Dir.pwd but the caller files position)
if you pass multiple string as argument it will be joined by file separator that the OS use

```ruby

    require 'loader'

    # load all ruby file that was not loaded already
    # from that relative folder
    require_relative_directory "folder_name"

    # for recursive use try the following
    require_relative_directory_r "folder_name/path/etc"


```

If you like the basic idea that the app should not do any kind of Eager Load and become slow,
you can use the constant based autoload function

simple as this:

# lib/dog
```ruby

  class Dog
    def self.say
      "Wuff"
    end
  end

```

# lib/cat
```ruby

  class Cat
    #some meow here
  end

```

# lib/cat/tail
```ruby

  class Cat
    class Tail

      def self.grab
        "MEOW!!!"
      end

    end
  end

```

# lib/cat/pawn.rb
```ruby

  class Cat
    class Pawn
    end
  end

```

# lib/bootstrap
```ruby

    require 'loader/autoload'

    # from this point missing constants will be searched by file system path that is based on Object namespace
    Loader.autoload

    # no need to load the files , only when they required
    Cat::Tail.grab #> "MEOW!!!"

    class Cat
      Pawn #> Pawn Constant loaded and returned
    end

    class Cat
      Dog #> return Top lvl Dog Constant after file is loaded by this Constant request
    end

```