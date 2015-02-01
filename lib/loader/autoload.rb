module Loader

  module AutoLoad
    module Support
      class << self

        def pwd
          if !!ENV['BUNDLE_GEMFILE']
            ENV['BUNDLE_GEMFILE'].split(File::Separator)[0..-2].join(File::Separator)
          elsif defined?(Rails) && Rails.respond_to?(:root) && Rails.root
            Rails.root.to_s
          else
            Dir.pwd
          end
        end

        def try_load_by(caller_class,name)
          levels = generate_levels(caller_class, name)
          [
              nil,
              'lib',
              File.join('{application,app,api}','*'),
              File.join('**','*')
          ].each do |folder|
            return if load_by_folder(levels,folder)
          end
        end

        def load_by_folder(levels,folder=nil)

          desc_ary(levels.map{|str| File.join(*[pwd,folder,"#{underscore(str)}.rb"].compact)}).each do |path_constructor|
            desc_ary(Dir.glob(path_constructor)).each do |path|
              return true if File.exist?(path) && require(path)
            end
          end

          return false

        end

        def desc_ary(array)
          array.sort{|a,b| b.length <=> a.length }
        end

        def generate_levels(klass, name)
          levels = klass.to_s.split('::').reduce([]) { |m, c|
            m << [(last_obj = m.last), c].compact.join('::');m
          }.map { |str| [str, name].join('::') }
          levels.unshift(name.to_s)
          return levels
        end

        def try_fetch_constant(caller_class, name)
          levels = Support.generate_levels(caller_class, name).map { |str| Regexp.escape(str) }
          ObjectSpace.each_object(Module) { |obj|
            if !!(obj.to_s =~ /^(#{levels.join('|')})$/)
              return obj
            end
          };nil
        end

        # Based on ActiveSupport, removed inflections.
        # https://github.com/rails/rails/blob/v4.1.0.rc1/activesupport/lib/active_support/inflector/methods.rb
        def underscore(camel_cased_word)
          word = camel_cased_word.to_s.gsub('::', '/')
          word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
          word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
          word.tr!("-", "_")
          word.downcase!
          word
        end

      end
    end

    def const_missing(name)

      Support.try_load_by(self,name)
      constant = Support.try_fetch_constant(self, name)

      if constant
        return constant
      else
        super
      end

    end

  end

  def self.autoload
    ::Module.__send__(:prepend,Loader::AutoLoad)
  end

end