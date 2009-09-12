require 'find'
#
# QuickServe::Listener
#
# The generic Listener, which polls the files after a specific interval
#
module QuickServe
  class Listener
      attr_accessor :files, :interval, :busy, :notifier, :parent, :mappings
      
      # constructor
      def initialize
        self.interval = 2 # decrease the CPU load by increasing the interval
        self.busy     = false
      end 
      
      # find files and start the listener
      def start
        puts "** #{self.class} is scanning for files... "
        # build a file collection
        find_files
        puts "** #{self.class} watching #{files.size} files... "
        wait  
      end
      
      # wait for a specified interval and check files for changes
      # source: ZenTest/autotest.rb
      def wait
        Kernel.sleep self.interval until check_files
      end
      
      # check files to find these that have changed
      def check_files
        return if busy # if working on something already, skip the iteration
        updated = []
        files.each do |filename, mtime| 
          begin
            current_mtime = File.stat(filename).mtime
          rescue Errno::ENOENT
            # file was not found and was probably deleted
            # remove the file from the file list 
            files.delete(filename)
            next
          end
          if current_mtime != mtime  
            updated << filename
            # update the mtime in file registry so we it's only send once
            files[filename] = current_mtime
            # puts ">> Spotted change in #{filename}"
          end
        end
        QuickServe::Rails.free if updated != []
        false
      end
       
      ##
      # Find the files to process, ignoring temporary files, source
      # configuration management files, etc., and return a Hash mapping
      # filename to modification time.
      # source: ZenTest/autotest.rb
      def find_files
        result = {}
        targets = ['app'] # start simple
        targets.each do |target|
          order = []
          Find.find(target) do |f|
            in_mappings = f =~ self.mappings
            next if in_mappings.nil?
            next if test ?d, f
            next if f =~ /(swp|~|rej|orig)$/ # temporary/patch files
            next if f =~ /(\.svn|\.git)$/ # subversion/git
            next if f =~ /\/\.?#/ # Emacs autosave/cvs merge files
            #next if !f.match?('.erb') and !f.match?('.rb')
            filename = f.sub(/^\.\//, '')

            result[filename] = File.stat(filename).mtime rescue next
          end
        end
        
        self.files = result
      end
      
  end
end