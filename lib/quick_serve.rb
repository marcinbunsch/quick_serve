if defined?(RAILS_ENV)
  if RAILS_ENV == 'development'
    require 'quick_serve/rails'
  else
    puts "** quick_serve: quick_serve can run only in development environment"
  end
else
  begin
    require 'mongrel' 
  rescue LoadError
    puts "quick_serve requires mongrel. Install it with: gem install mongrel"
    exit(1)
  end

  require 'quick_serve/server'
  require 'quick_serve/snapshot_handler'
end
