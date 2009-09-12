# Here we hack mongrel do jump in front of the handler
module Mongrel
  module Rails
    
    class RailsHandler 
    
      alias_method :original_process, :process
      
      def process(request, response)
        #response.start do |head,out|
        #  puts "** quick_serve: served snapshot"
        #  head["Content-Type"] = "text/html"
        #  out << "foo"
        #end
        #puts "=== quick_serve ==="
        original_process(request, response)
        #debugger
        #puts 'dsa'
        #debugger
        #puts
        #debugger
      end
      
    end
    
  end
end

module ActionController
  class Dispatcher
    
    after_dispatch :store_snapshot
    def store_snapshot
      debugger
      puts 'dsd'
      if !@response.redirected_to
        #QuickServe::Rails.store(@request.url, @response.body)
        #debugger
        #puts 'dsd'
      end
    end
  end
end

module QuickServe
  class Rails
    @@snapshots = {}
    
    def self.free
      @@snapshots = {}
    end
    
    def self.store(key, snapshot)
      @@snapshots[key] = snapshot
    end
    
    def self.fetch(key)
      @@snapshots[key]
    end
    
  end
end
puts "** quick_serve: attaching snapshot handler"