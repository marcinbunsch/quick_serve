# Here we hack mongrel do jump in front of the handler
module Mongrel
  module Rails
    class RailsHandler 
    
      alias_method :original_process, :process
      
      def process(request, response)
        # only serve GET
        return original_process(request, response) if request.params['REQUEST_METHOD'] != 'GET'
        url = 'http://' + request.params["HTTP_HOST"] + request.params["REQUEST_URI"]
        snapshot = QuickServe::Rails::Snapshot.fetch(url)
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