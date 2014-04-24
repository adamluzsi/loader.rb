module Loader

  module ObjectRequireEXT

    # Offline repo activate
    #def mount_modules(target_folder= File.join(Dir.pwd,"{module,modules}","{gem,gems}") )
    #  Dir.glob(File.join(target_folder,"**","lib")).select{|f| File.directory?(f)}.each do |one_path|
    #    $LOAD_PATH.unshift one_path
    #  end
    #end

    # require sender relative directory's files
    # return the directory and the sub directories file names (rb/ru)
    def require_relative_directory( folder, *args )

      recursive= nil
      [:recursive,:r, :R, 'r', 'R', '-r', '-R'].each{|e| args.include?(e) ? recursive ||= true : nil }

      # opts[:extension] ||= opts[:extensions] || opts[:ex] || opts[:e] || []
      # raise(ArgumentError,"invalid extension object, must be array like") unless opts[:extension].class <= Array

      unless folder.to_s[0] == File::Separator
        folder= [Loader.caller_folder,folder]
      end

      path_parts= [*folder]
      if recursive
        path_parts.push("**")
      end
      path_parts.push("*.{rb,ru}")

      puts path_parts.inspect

      return_value= false
      Dir.glob(File.join(*path_parts)).each do |one_path|
        require(one_path) ? return_value=( true ) : nil
      end

      return return_value
    end

    alias :require_directory :require_relative_directory

    def require_relative_directory_r folder

      unless folder.to_s[0] == File::Separator
        folder= File.join(Loader.caller_folder,folder)
      end

      require_relative_directory folder,:r

    end
    alias :require_directory_r :require_relative_directory_r

  end

end

Object.__send__ :include, Loader::ObjectRequireEXT