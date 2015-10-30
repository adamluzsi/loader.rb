
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