module QuickServe

  class SnapshotHandler < Mongrel::HttpHandler
  
    def initialize(url)
      @url = url
      @https = (url.match('https:') ? true : false)
      @host = url.gsub(/(http)(s*)(\:\/\/)/, '').split('/').first
      @snapshot = nil
      fetch
      super()
    end
  
    def fetch
      require 'open-uri'
      @snapshot = open(@url).read
      host_root = (@https ? 'https://' : 'http://') + @host + '/'
      @snapshot.gsub!(/(href=|src=)(['"])(\/)/, "\\1\\2#{host_root}\\4")
    end
  
    def process(request, response)
      response.start do |head,out|
        puts "quick_serve: served snapshot of #{@url}"
        head["Content-Type"] = "text/html"
        out << @snapshot
      end
    end
  
  end

end