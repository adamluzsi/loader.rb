module Loader::Fetcher

  extend self
  extend ::Loader::Utils

  def load_gem(caller_class, constant_name)
    underscore_name = Loader::Utils.underscore(constant_name)
    gem_symbolic_name = underscore_name.sub(File::Separator, '-')

    begin
      require(underscore_name)
    rescue LoadError
      require(gem_symbolic_name)
    end

    return fetch_constant(caller_class, constant_name)
  rescue LoadError
    nil
  end

  def load(caller_class, name)
    folder_path = get_folder_path(caller_class)
    file_name = Loader::Utils.underscore(name)

    Loader.project_root_folders.each do |project_root|
      Dir.glob(File.join(project_root, '**', [folder_path, "#{file_name}.{rb,ru}"].compact)).each do |ruby_file_path|
        if Loader::Utils.require(ruby_file_path)
          c = fetch_constant(caller_class, name)

          return c unless c.nil?
        end
      end
    end

    return load_gem(caller_class, name)
  end


  protected

  def get_folder_path(caller_class)
    return if caller_class == ::Object
    caller_class.to_s.split('::').map { |camel_case| Loader::Utils.underscore(camel_case) }.join(File::Separator)
  end

  def fetch_constant(caller_class, name)
    class_name = ([caller_class, name] - [Object]).join('::')
    rgx = /^#{Regexp.escape(class_name)}$/

    ObjectSpace.each_object(Module) do |obj|
      return obj if !!(obj.to_s =~ rgx)
    end

    return nil
  end

end