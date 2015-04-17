module Loader::AutoLoad::ModulePatch

  def const_missing(name)
    c = Loader::AutoLoad::Fetcher
    c.try_load_by(self,name)
    constant = c.try_fetch_constant(self, name)
    constant ? constant : super
  end

end