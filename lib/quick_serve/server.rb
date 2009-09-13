module QuickServe
  class Server
  
    def initialize
      @options = { :dir => '.', :port => 5000, :host => '0.0.0.0', :deamon => false, :url => nil }
      parse
    end

    def start
      if @options[:url]
        puts "quick_serve: running in snapshot mode using #{@options[:url]} as source"
      else
        puts "quick_serve: mongrel running on port #{@options[:port]} current directory as docroot"
      end
      begin
        if @options[:deamon]
          pid = fork do
            $stderr, $stdout = StringIO.new, StringIO.new
            serve
          end
          File.open(pidfile, 'w') {|f| f.write(pid) }      
        else
          serve
        end
      rescue Errno::EADDRINUSE
        puts "quick_serve: port #{@options[:port]} is used by another process. Please specify other port using the -p option"
      end
    end
  
    private

      def serve
        options = @options
        config = Mongrel::Configurator.new :host => options[:host], :port => options[:port] do
          listener do
            if options[:url]
              require 'quick_serve/snapshot/handler'
              uri "/", :handler => QuickServe::Snapshot::Handler.new(options[:url])
            else
              uri "/", :handler => Mongrel::DirHandler.new(options[:dir])
            end  
          end
          trap("INT") { stop }
          run
        end
        config.join
      end
    
      def parse
        require 'optparse'
        OptionParser.new do |opts|
          opts.banner = "Usage: qs [options]"

          opts.on("-p PORT", "--port PORT", "Specify port") { |value| @options[:port] = value; }
          opts.on("--dir DIRECTORY", "Specify directory to act as docroot") { |value| @options[:dir] = value; }
          opts.on("--host HOST", "Specify host") { |value| @options[:host] = value; }
          opts.on("-s URL", "--snapshot URL", "Specify url for snapshot") { |value| @options[:url] = value; }
          opts.on("-q", "quit deamon (if present)") { quit }
          opts.on("-d", "--deamon", "Run as a deamon process") { @options[:deamon] = true; }
          opts.on_tail("-h", "--help", "Show this message") do
            puts opts
            exit
          end
        end.parse!
      end
    
      def quit
      
        print "Stopping quick serve... "
        die(" pid file not found") if !File.exists?(pidfile)
        pid = File.read(pidfile)
        begin
          if Process.kill("INT", pid.to_i) == 1
            puts ' ok'
            File.delete(pidfile) if File.exist?(pidfile)
          end
        rescue Errno::ESRCH
          puts ' not found'
        end
        exit
      end
  
      def pidfile
        File.join(@options[:dir], "qs.#{@options[:port]}.pid")
      end
    
      def die(msg)
        puts msg
        exit(1)
      end
  end
end