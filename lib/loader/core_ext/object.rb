Object.class_eval do

  def require_relative_directory(relative_directory_path)
    Dir.glob(File.join(File.dirname(caller[0]), relative_directory_path, '*.{ru,rb}'))
        .sort_by { |file_path| file_path.length }
        .each { |file_path| Loader::Utils.require(file_path) }

  end

end