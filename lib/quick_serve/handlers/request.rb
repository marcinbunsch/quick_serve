module QuickServe
  module Handlers
    class Request < Directory
  
      def initialize(dir)
        @responses = {}
        responses = File.read(File.join("#{Dir.pwd}", 'responses.qs')).gsub(/#.*/, '').split('==')[1..-1]
        responses.each do |response|
          parts = response.split("\n")
          method, url, content_type   = parts.shift.gsub(/(^\s)(.*)(\s$)/, '\\2').gsub(/(\s+)/, ' ').split(' ')      
          body = parts.join("\n")
          @responses["#{method} #{url}"] = {
            :body => body,
            :content_type => (content_type || "text/html")
          }
        end
        super
      end
  
      alias :original_process :process
      
      def process(request, response)
        method = request.params['REQUEST_METHOD'].downcase
        if method == 'post'
          params = {}
          raw = request.body.read
          raw.split('&').each { |param| parts = param.split('='); params[parts.first] = parts.last }
          method = params['_method'] if params['_method'] and ['put', 'delete'].include?(params['_method'])
        end
        url = request.params['REQUEST_PATH']
        qs_response = @responses["#{method} #{url}"]
        # if not found, try a more generic approach
        if !qs_response
          url.gsub!(/(\d+)/, '*')
          qs_response = @responses["#{method} #{url}"]
        end
        if qs_response
          response.start do |head,out|
            puts "quick_serve: served #{qs_response[:content_type]} response for of #{url}"
            head["Content-Type"] = qs_response[:content_type]
            out << qs_response[:body]
          end
        else
          original_process(request, response)  
        end
        
      end
  
    end
  end
end