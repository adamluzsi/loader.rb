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

    # pre format
    begin

      # path create from caller
      begin
        path= caller[0].split(".{rb,ru}:").first.split(File::SEPARATOR)
        path= path[0..(path.count-2)]
      end

      # after formatting
      begin

        if !File.directory?(path.join(File::SEPARATOR))
          path.pop
        end
        path= File.join(path.join(File::SEPARATOR))
        if path != File.expand_path(path)
          path= File.expand_path(path)
        end

      end

    end

    # find elements
    begin
      return Dir.glob(File.join(path,folder,"**","*.{rb,ru}")).each do |one_path|
        require one_path
      end
    end

  end

end