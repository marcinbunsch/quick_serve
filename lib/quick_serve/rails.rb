require 'quick_serve/rails/snapshot'
require 'quick_serve/rails/listener'
require 'quick_serve/rails/ext/mongrel'
require 'quick_serve/rails/ext/rails'
puts "** quick_serve: attaching rails snapshot handler"
Thread.new { QuickServe::Rails::Listener.new.start }