module ActionController
  class Base
    after_filter :store_snapshot
    def store_snapshot
      puts "quick_serve: stored snapshot as #{request.url}"
      # do not store redirects or pages with flash
      QuickServe::Rails::Snapshot.store(request.url, response.body) if !response.redirected_to and flash == {}
    end
  end
end

module ActiveRecord
  class Base
    
    after_save :free_snapshots
    after_destroy :free_snapshots
    
    def free_snapshots
      QuickServe::Rails::Snapshot.reset
    end
    
  end
end