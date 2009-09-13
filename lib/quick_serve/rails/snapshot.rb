# Storage for snapshots of pages generated by rails
module QuickServe
  module Rails
    class Snapshot
      @@snapshots = {}
    
      # return collection
      def self.dump
        @@snapshots
      end
    
      # remove all snapshots
      def self.reset
        @@snapshots = {}
      end
    
      # store a snapshot under specified key
      def self.store(key, snapshot)
        @@snapshots[key] = snapshot
      end
    
      # fetch a snapshot stored under specified key
      def self.fetch(key)
        @@snapshots[key]
      end
    end
  end
end