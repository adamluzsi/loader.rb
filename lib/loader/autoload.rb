require 'loader'
module Loader::AutoLoad
  require 'loader/autoload/module_patch'
  require 'loader/autoload/loader_patch'
  require 'loader/autoload/fetcher'
  Loader.__send__(:extend,Loader::AutoLoad::LoaderPatch)
end