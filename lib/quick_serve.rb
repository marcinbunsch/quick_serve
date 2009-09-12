begin
  require 'mongrel' 
rescue LoadError
  puts "quick_serve requires mongrel. Install it with: gem install mongrel"
  exit(1)
end

require 'quick_serve/server'
require 'quick_serve/snapshot_handler'



