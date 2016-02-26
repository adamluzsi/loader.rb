Object.class_eval do

  def require_relative_directory(relative_directory_path)
    file_paths = Dir.glob(File.join(File.dirname(caller[0]), relative_directory_path, '*.{ru,rb}'))
    file_paths = file_paths.sort_by { |file_path| file_path.length }
    file_paths.each { |file_path| Loader::Utils.require(file_path) }
  end

end