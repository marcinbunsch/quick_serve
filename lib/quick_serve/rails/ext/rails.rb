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
      # if rails uses active_record store, it changes with each request, making quick_serve unusable
      # this probably should be a config option (somehow)
      return if self.class.to_s == 'CGI::Session::ActiveRecordStore::Session'
      puts "quick_serve: detected change in #{self.class}"
      QuickServe::Rails::Snapshot.reset
    end
    
  end
end
