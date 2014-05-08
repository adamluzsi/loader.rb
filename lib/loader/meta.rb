module Loader

  module ObjectCallerEXT

    def __directory__
      caller_folder(-1)
    end

    alias :__DIR__ :__directory__

    def caller_file skip= 0

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

  end
  extend ObjectCallerEXT

  class << self

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

        input_config_file   = opts[:f]  || opts[:config_file]
        target_config_hash  = opts[:o]  || opts[:out]           || opts[:config_obj]    || {}
        root_folder         = opts[:r]  || opts[:root]          || caller_root_folder
        config_folder       = opts[:d]  || opts[:config_folder] || File.join(root_folder,"{config,conf}","**")
        lib_folder          = opts[:l]  || opts[:lib]           || opts[:lib_folder]    || File.join(root_folder,"{lib,libs}","**","meta")
        environment         = opts[:e]  || opts[:env]           || opts[:environment]
        raise unless target_config_hash.class <= Hash

      end

      deep_merge! target_config_hash, Loader.meta( absolute: lib_folder )

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
              deep_merge!(target_config_hash,yaml_data)

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
    alias :metaframework :metaloader_framework

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

      options= args.select{|e|(e.class <= ::Hash)}
      args -= options
      options= Hash[*options]

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

Object.__send__ :include, Loader::ObjectCallerEXT