Module.class_eval do

  alias const_missing_original const_missing

  def const_missing(name)
    constant = Loader::Fetcher.load(self, name)
    constant || const_missing_original(name)
  end

end