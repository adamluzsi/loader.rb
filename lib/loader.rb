#encoding: UTF-8
module Loader

  require 'loader/utils'
  require 'loader/fetcher'
  require 'loader/core_ext'

  extend self

  def project_root_folders
    @project_root_folders ||= []
  end

  def autoload!(project_root_folder=Loader::Utils.pwd)
    project_root_folders.push(File.expand_path(project_root_folder))
  end

  alias autoload autoload!

end