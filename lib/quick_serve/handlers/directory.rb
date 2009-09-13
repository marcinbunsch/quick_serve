module QuickServe
  module Handlers
    class Directory < Mongrel::DirHandler

      STYLESHEET = <<-stylesheet
      html, body {
        font-family: "Lucida Grande", Verdana, sans-serif;
        font-size: 90%;
        font-weight: normal;
        line-height: auto;
      }
      html {
        background-color: #F0F0F0;
      }
      #body {
        -moz-border-radius-bottomleft:10px;
        -moz-border-radius-bottomright:10px;
        -moz-border-radius-topleft:10px;
        -moz-border-radius-topright:10px;
        background-color: #fff;
        border:1px solid #E1E1E1;
        color:-moz-fieldtext;
        width: 70%;
        margin:4em auto;
        padding:3em;
      }
      h1 {
        font-size: 130%;
        border-bottom: 1px solid #999;
        padding: 3px;
      }
      a {
        color: #666;
        text-decoration: none
      }
      a:hover { color: #000 }
      h3 { 
        font-size: 115%;
        margin-bottom: 10px; 
      }
      stylesheet
      
      def send_dir_listing(base, dir, response)
        # take off any trailing / so the links come out right
        base = Mongrel::HttpRequest.unescape(base)
        base.chop! if base[-1] == "/"[-1]

        if @listing_allowed
          response.start(200) do |head,out|
            head[Mongrel::Const::CONTENT_TYPE] = "text/html"
            
            out << "<html><head><title>Directory Listing for #{dir}</title><style type=\"text/css\">#{STYLESHEET}</style></head><body><div id=\"body\"><h1>Directory Listing for #{dir}</h1>"
            entries = Dir.entries(dir)
            entries = entries - ['..']
            out << "<h3><a href=\"#{base}/..\">Up to higher level directory</a></h3>"
            entries.each do |child|
              next if child == "."
              out << "<a href=\"#{base}/#{ Mongrel::HttpRequest.escape(child)}\">"
              out << child
              out << "</a><br/>"
            end
            out << "</div></body></html>"
          end
        else
          response.start(403) do |head,out|
            out.write("Directory listings not allowed")
          end
        end
      end
      
    end
  end
end

