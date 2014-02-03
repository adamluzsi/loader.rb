#encoding: UTF-8
module Loader

  require "yaml"

  require File.join(File.dirname(__FILE__),"loader","array")
  require File.join(File.dirname(__FILE__),"loader","hash")
  require File.join(File.dirname(__FILE__),"loader","meta")
  require File.join(File.dirname(__FILE__),"loader","require")

end
