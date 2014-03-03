module Loader
  class << self

    def directory_path
      self.caller_folder
    end

    alias :directory :directory_path

    # gives you a basic meta load framework for easy config use (yaml)
    # basic system is
    #
    # root folder:
    # - config
    # -| "YAML files" #> development.yaml
    #
    # - lib
    # -- module_name
    # --- meta
    # ---| "YAML files" #> rack.yaml
    #
    def metaloader_framework(opts={})

      # defaults
      begin

        root_folder         =  opts[:root]
        root_folder        ||= caller_root_folder

        target_config_hash  =  opts[:config_obj]
        target_config_hash ||= Hash.new

        lib_folder          =  opts[:lib_folder]
        lib_folder         ||= File.join(root_folder,"{lib,libs}","**","meta")

        config_folder       =  opts[:config_folder]
        config_folder      ||= File.join(root_folder,"{config,conf}","**")

        input_config_file   =  opts[:config_file]
        environment         =  opts[:environment]

      end

      target_config_hash.deep_merge! Loader.meta( absolute: lib_folder )

      # update by config
      begin

        # get config files
        begin
          config_yaml_paths= Array.new()
          Dir.glob(File.join(config_folder,"*.{yaml,yml}")).uniq.each do |one_path|

            case true

              when one_path.downcase.include?('default')
                config_yaml_paths[0]= one_path

              when one_path.downcase.include?('development')
                config_yaml_paths[1]= one_path

              when one_path.downcase.include?('test')
                config_yaml_paths[2]= one_path

              when one_path.downcase.include?('production')
                config_yaml_paths[3]= one_path

              else
                config_yaml_paths[config_yaml_paths.count]= one_path

            end

          end
          config_yaml_paths.select!{|x| x != nil }
        end

        # params config load
        unless input_config_file.nil?
          begin
            path= File.expand_path(input_config_file,"r")
            File.open(path)
            config_yaml_paths.push(path)
          rescue Exception
            config_yaml_paths.push(input_config_file)
          end
        end

        # load to last lvl environment
        begin
          config_yaml_paths.each do |one_yaml_file_path|
            begin
              yaml_data= YAML.load(File.open(one_yaml_file_path))
              target_config_hash.deep_merge!(yaml_data)

              unless environment.nil?
                if one_yaml_file_path.include?(environment.to_s)
                  break
                end
              end
            rescue Exception
            end
          end
        end

      end

      return target_config_hash

    end

    def caller_folder integer_num= 1

      # path create from caller
      begin
        path= caller[integer_num].split(".{rb,ru}:").first.split(File::Separator)
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

      return path

    end

    # you can give optional file names that will be searched for
    def caller_root(*args)

      what_can_be_in_the_root= %w[
              gemfile Gemfile GemFile
              rakefile Rakefile RakeFile
              config.ru README.md ] + args.map{|e|e.to_s}

      folder_path= caller_folder(2).split(File::Separator)

      loop do

        Dir.glob(File.join(folder_path.join(File::Separator),"*")).map do |element|
          if !File.directory?(element)
            if what_can_be_in_the_root.include? element.split(File::Separator).last
              return folder_path.join(File::Separator)
            end
          end
        end

        if folder_path.count != 0
          folder_path.pop
        else
          return nil
        end

      end

    end

    alias :caller_root_folder :caller_root

    # load meta folders rb files
    # by default it will be the caller objects root folder (app root)
    # else you must set with hand the path  from your app root
    # example:
    #
    #  Loader.meta
    #
    #  Loader.meta 'lib','**','config_files'
    #
    #  Loader.meta root: "/home/...../my_app",'lib','**','meta'
    #
    #  Loader.meta 'lib','**','meta',
    #              root: "/home/...../my_app"
    #
    # You can use the "absolute: string_path" option just alike so it wont try find your
    # app root folder
    #
    # All will return a Hash obj with the loaded meta configs based on the
    # yaml file name as key and the folder as the category
    def meta( *args )

      options= args.extract_class!(Hash)[0]
      options ||= {}

      if options[:absolute].nil?

        if args.empty?
          args= ["{lib,libs,library,libraries}","**","meta"]
        end

        if !options[:root].nil?
          root_folder_path= options[:root]
        else
          root_folder_path= caller_root_folder
        end

        args.unshift(root_folder_path)

      else
        args= [options[:absolute]]
      end

      target_folder= File.join(*args)

      # load ruby files from meta
      begin
        Dir.glob( File.join(target_folder,"*.{rb,ru}") ).each do |one_rb_file|
          require one_rb_file
        end
      end

      # load yaml files elements
      begin

        target_config_hash= Hash.new
        Dir.glob(File.join(target_folder,"*.{yaml,yml}")).each do |config_object|

          # defaults
          begin
            config_name_elements= config_object.split(File::SEPARATOR)

            type=     config_name_elements.pop.split('.')[0]
            config_name_elements.pop

            category= config_name_elements.pop
            yaml_data= YAML.load(File.open(config_object))
          end

          # processing
          begin
            target_config_hash[category]       ||= {}
            target_config_hash[category][type] ||= {}
            target_config_hash[category][type]  =  yaml_data
          end

        end

      end

      # return data
      begin
        return target_config_hash
      end

    end


  end
end