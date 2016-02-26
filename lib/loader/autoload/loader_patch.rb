module Loader::AutoLoad::LoaderPatch

  def project_folders
    @project_folders ||= []
  end

  def autoload!(project_folder=Loader::Helpers.pwd)
    project_folders.push(project_folder)
    ::Module.__send__(:prepend, Loader::AutoLoad::ModulePatch)
  end

  alias autoload autoload!

end