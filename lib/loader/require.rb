module Loader

  module ObjectRequireEXT

    # require sender relative directory's files
    # return the directory and the sub directories file names (rb/ru)
    def require_relative_directory *args

      folder= args.select{|e|(e.class <= ::String)}.join(File::Separator)
      opts=   ::Hash[*args.select{|e|(e.class <= ::Hash)}]
      args.select!{|e|(e.class <= ::Symbol)}

      opts[:recursive]  ||= opts.delete(:r) || opts.delete(:R) || !([:recursive,:r, :R,].select{|e| args.include?(e)}.empty?)
      opts[:recursive]    = !!opts[:recursive]

      # inclusion and exclusion
      [[:exclude,[:ex,:e,:EX,:E]],[:include,[:in,:i,:IN,:I]]].each do |name,aliases|

        aliases.each do |one_alias|
          opts[name]    ||= opts.delete(one_alias)
        end

        opts[name] ||= []

        # should be REGEXP collection
        opts[name] = [*opts[name]].map{|e| !(e.class <= ::Regexp) ? Regexp.new(e.to_s) : e }

      end


      opts[:caller_folder]  ||= opts.delete(:f) || opts.delete(:folder) || ::Loader.caller_folder

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

        next unless opts[:exclude].select{|regex| one_path =~ regex ? true : false }.empty?

        if opts[:include].empty?
          require(one_path);one_path
        else
          opts[:include].each do |regex|
            if one_path =~ regex
              require(one_path);one_path
            end
          end
        end

      }.compact

    end

    alias :require_directory :require_relative_directory

    def require_relative_directory_r *args
      require_relative_directory *args, r: true, f: Loader.caller_folder
    end
    alias :require_directory_r :require_relative_directory_r

  end

end

Object.__send__ :include, Loader::ObjectRequireEXT
