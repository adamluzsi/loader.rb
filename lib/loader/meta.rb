module Loader

  class << self

    def caller_file(skip=0)

      raise unless skip.class <= Integer
      skip += 1

      return nil if caller[skip].nil?
      caller_file = caller[skip].scan(/^(.*)(:\d+:\w+)/)[0][0]

      if caller_file[0] != File::Separator
        caller_file= File.expand_path caller_file
      end

      return caller_file

    end

    def caller_folder skip= 0

      raise unless skip.class <= Integer
      caller_file_path= caller_file(skip+1)
      return nil if caller_file_path.nil?

      if !File.directory?(caller_file_path)
        caller_file_path= caller_file_path.split(File::Separator)
        caller_file_path.pop
        caller_file_path= caller_file_path.join(File::Separator)
      end

      return caller_file_path

    end



    # you can give optional file names that will be searched for
    def caller_root(*args)

      what_can_be_in_the_root= %w[
              gemfile Gemfile GemFile
              rakefile Rakefile RakeFile
              config.ru README.md LICENSE LICENSE.txt .gitignore ] + args.map{|e|e.to_s}

      folder_path= caller_folder(1).split(File::Separator)

      loop do

        Dir.glob(File.join(folder_path.join(File::Separator),"*")).map do |element|
          if !File.directory?(element)
            if what_can_be_in_the_root.include? element.split(File::Separator).last
              return folder_path.join(File::Separator)
            end
          else
            if %W[ .git .bundler ].include? element.split(File::Separator).last
              return folder_path.join(File::Separator)
            end
          end
        end

        if folder_path.count == 0
          return nil
        else
          folder_path.pop
        end

      end

    end

    alias :caller_root_folder :caller_root

  end

end

# Object.__send__ :include, Loader::ObjectCallerEXT