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
    Loader.project_root_folders.each do |project_root|
      lookup_and_load_file_in(project_root, caller_class, name)

      constant = fetch_constant(caller_class, name)

      return constant unless constant.nil?
    end

    return load_gem(caller_class, name)
  end

  def lookup_and_load_file_in(project_root, caller_class, name)
    file_name = Loader::Utils.underscore(name)

    get_folder_paths(caller_class).each do |folder_path|
      Dir.glob(File.join(project_root, '**', folder_path, "#{file_name}.{rb,ru}")).each do |ruby_file_path|
        return if Loader::Utils.require(ruby_file_path)
      end
    end
  end


  protected

  def get_folder_paths(caller_class)

    elements = caller_class.to_s.split('::').map do |camel_case|
      Loader::Utils.underscore(camel_case)
    end

    elements.shift if elements[0] == 'object'

    return elements.reverse.reduce(['**']) { |constant_paths, name_part|
      last_element = constant_paths.last
      constant_paths.push(File.join([last_element, name_part].compact.reverse))
      constant_paths
    }.reverse

  end

  def fetch_constant(caller_class, name)
    constant_paths = get_constant_paths(caller_class, name)

    constant_paths.each do |constant_path|

      rgx = /^#{Regexp.escape(constant_path)}$/

      ObjectSpace.each_object(Module) do |obj|
        return obj if !!(obj.to_s =~ rgx)
      end

    end


    return nil
  end

  def get_constant_paths(caller_class, name)
    elements = [caller_class.to_s.split('::'), name.to_s].flatten
    elements.shift if elements[0] == 'Object'
    return elements.reverse.reduce([]) { |constant_paths, name_part|
      last_element = constant_paths.last

      constant_paths.push(File.join([last_element, name_part].compact.reverse.join('::')))
      constant_paths
    }.reverse
  end

end