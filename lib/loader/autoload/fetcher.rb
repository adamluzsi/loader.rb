module Loader::AutoLoad::Fetcher

  extend self
  extend ::Loader::Helpers

  def try_load_by(caller_class, name)
    levels = generate_levels(caller_class, name)
    [
        nil,
        'lib',
        File.join('{application,app,api}', '*'),
        File.join('**', '*')
    ].each do |folder|
      return if load_by_folder(levels, folder)
    end
  end

  def load_by_folder(levels, folder=nil)

    Loader.project_folders.each do |project_folder|

      desc_ary(levels.map { |str| File.join(*[project_folder, folder, "#{underscore(str)}.rb"].compact) }).each do |path_constructor|
        desc_ary(Dir.glob(path_constructor)).each do |path|
          return true if File.exist?(path) && require(path)
        end
      end

    end

    return false

  end

  def desc_ary(array)
    array.sort { |a, b| b.length <=> a.length }
  end

  def generate_levels(klass, name)
    levels = klass.to_s.split('::').reduce([]) { |m, c|
      m << [(last_obj = m.last), c].compact.join('::'); m
    }.map { |str| [str, name].join('::') }
    levels.unshift(name.to_s)
    return levels
  end

  def try_fetch_constant(caller_class, name)
    levels = generate_levels(caller_class, name).map { |str| Regexp.escape(str) }
    ObjectSpace.each_object(Module) { |obj|
      if !!(obj.to_s =~ /^(#{levels.join('|')})$/)
        return obj
      end
    }; nil
  end
  
end