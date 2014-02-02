module Loader
  class << self



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

        root_folder        = opts[:root]
        override           = opts[:override]
        target_config_hash = opts[:config]
        lib_folder         = opts[:lib_folder]
        config_folder      = opts[:config_folder]


        override           ||= true
        root_folder        ||= Dir.pwd
        target_config_hash ||= Application.config

        lib_folder         ||= File.join(root_folder,"{lib,libs}","**","meta")
        config_folder      ||= File.join(root_folder,"{config,conf}","**")

        require "yaml"
        if target_config_hash.class != Hash
          target_config_hash= Hash.new()
        end

      end

      # find elements
      begin

        #TODO meta DRY here!
        Dir.glob(File.join(lib_folder,"*.{yaml,yml}")).each do |config_object|

          # defaults
          begin
            config_name_elements= config_object.split(File::SEPARATOR)
            type=                 config_name_elements.pop.split('.')[0]
            config_name_elements.pop

            category  = config_name_elements.pop
            tmp_hash  = Hash.new()
            yaml_data = YAML.load(File.open(config_object))
          end

          # processing
          begin
            if target_config_hash[category].nil?
              target_config_hash[category]= { type => yaml_data }
            else
              unless override == false
                target_config_hash[category][type]= yaml_data
              end
            end
          end

        end

      end

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
        unless Application.config_file.nil?
          begin
            path= File.expand_path(Application.config_file,"r")
            File.open(path)
            config_yaml_paths.push(path)
          rescue Exception
            config_yaml_paths.push(Application.config_file)
          end
        end

        # load to last lvl environment
        begin
          config_yaml_paths.each do |one_yaml_file_path|
            begin
              yaml_data= YAML.load(File.open(one_yaml_file_path))
              target_config_hash.deep_merge!(yaml_data)

              unless Application.environment.nil?
                if one_yaml_file_path.include?(Application.environment.to_s)
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

    def caller_root

      sender_folder_path= caller_folder(2).split(File::Separator)
      Dir.glob(sender_folder_path.join(File::Separator)).each do |e|
        puts e
      end



    end

    # load meta folders rb files
    def meta( target_folder = nil )

      caller_root

      #target_folder ||= caller_folder
      #
      ## find elements
      #begin
      #  Dir.glob( File.join(target_folder,"*.{rb,ru}") ).each do |one_rb_file|
      #    require one_rb_file
      #  end
      #end
      #
      ## defaults
      #begin
      #  target_config_hash= Hash.new()
      #end
      #
      ## find elements
      #begin
      #
      #  Dir.glob(File.join(target_folder,"*.{yaml,yml}")).each do |config_object|
      #
      #    # defaults
      #    begin
      #      config_name_elements= config_object.split(File::SEPARATOR)
      #      type=     config_name_elements.pop.split('.')[0]
      #      config_name_elements.pop
      #      category= config_name_elements.pop
      #      tmp_hash= Hash.new()
      #      yaml_data= YAML.load(File.open(config_object))
      #    end
      #
      #    # processing
      #    begin
      #      if target_config_hash[category].nil?
      #        target_config_hash[category]= { type => yaml_data }
      #      else
      #        target_config_hash[category][type]= yaml_data
      #      end
      #    end
      #
      #  end
      #
      #end
      #
      ## return data
      #begin
      #  return target_config_hash
      #end

    end


  end
end