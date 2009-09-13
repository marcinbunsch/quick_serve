# Here we hack mongrel do jump in front of the handler
module Mongrel
  module Rails
    class RailsHandler 
    
      alias_method :original_process, :process
      
      def process(request, response)
        # only serve GET
        return original_process(request, response) if request.params['REQUEST_METHOD'] != 'GET'
        url = 'http://' + request.params["HTTP_HOST"] + request.params["REQUEST_URI"]
        snapshot = QuickServe::Rails.fetch(url)
        if snapshot
          response.start do |head,out|
            puts "quick_serve: served snapshot of #{url}"
            head["Content-Type"] = "text/html"
            out << snapshot
          end
        else
          original_process(request, response)
        end
      end
      
    end
    
  end
end

module ActionController
  class Base
    after_filter :store_snapshot
    def store_snapshot
      puts "quick_serve: stored snapshot as #{request.url}"
      QuickServe::Rails.store(request.url, response.body) if !response.redirected_to
    end
  end
end

module ActiveRecord
  class Base
    
    after_save :free_snapshots
    after_destroy :free_snapshots
    
    def free_snapshots
      QuickServe::Rails.free
    end
    
  end
end

module QuickServe
  class Rails
    @@snapshots = {}
    
    def self.dump
      @@snapshots
    end
    
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
require 'quick_serve/listener'
Thread.new { QuickServe::Listener.new.start }