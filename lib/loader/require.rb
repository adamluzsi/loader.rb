module Kernel

  # Offline repo activate
  #def mount_modules(target_folder= File.join(Dir.pwd,"{module,modules}","{gem,gems}") )
  #  Dir.glob(File.join(target_folder,"**","lib")).select{|f| File.directory?(f)}.each do |one_path|
  #    $LOAD_PATH.unshift one_path
  #  end
  #end

  # require by absolute path directory's files
  def require_directory(folder)
    Dir.glob(File.join(folder,"**","*.{rb,ru}")).each do |file_path|
      require file_path
    end
  end

  # require sender relative directory's files
  # return the directory and the sub directories file names (rb/ru)
  def require_relative_directory(folder)

    unless folder.to_s[0] == File::Separator
      folder= Loader.caller_folder,folder
    end

    Dir.glob(File.join(folder,"**","*.{rb,ru}")).each do |one_path|
      require one_path
    end

    return nil

  end

end