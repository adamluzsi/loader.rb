module Loader

  module ObjectRequireEXT

    # require sender relative directory's files
    # return the directory and the sub directories file names (rb/ru)
    def require_relative_directory *args

      folder= args.select{|e|(e.class <= ::String)}.join(File::Separator)
      opts=   Hash[*args.select{|e|(e.class <= ::Hash)}]
      args=   args.select{|e|(e.class <= ::Symbol)}

      opts[:recursive]      ||= opts.delete(:r) || opts.delete(:R) || !([:recursive,:r, :R,].select{|e| args.include?(e)}.empty?)
      opts[:recursive]        = !!opts[:recursive]

      opts[:caller_folder]  ||= opts.delete(:f) || opts.delete(:folder) || Loader.caller_folder

      unless folder.to_s[0] == File::Separator
        folder= [opts[:caller_folder],folder]
      end

      #> recursive option
      begin
        path_parts= [*folder]
        if opts[:recursive]
          path_parts.push("**")
        end
        path_parts.push("*.{rb,ru}")
      end

      return Dir.glob(File.join(*path_parts)).sort_by{|e| e.split(File::Separator).size }.map { |one_path|
        require(one_path)
      }.include?(true)

    end

    alias :require_directory :require_relative_directory

    def require_relative_directory_r *args
      require_relative_directory *args, r: true, f: Loader.caller_folder
    end
    alias :require_directory_r :require_relative_directory_r

  end

end

Object.__send__ :include, Loader::ObjectRequireEXT
