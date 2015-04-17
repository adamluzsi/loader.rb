$LOAD_PATH.unshift(File.join(__dir__,'..','lib'))
require 'loader'

Loader.autoload __dir__

p Cat

