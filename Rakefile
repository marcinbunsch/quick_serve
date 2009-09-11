require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "quick_serve"
    gem.summary = %Q{Super simple web server mainly for javascript development}
    gem.description = %Q{}
    gem.email = "marcin@applicake.com"
    gem.homepage = "http://github.com/marcinbunsch/quick_serve"
    gem.authors = ["Marcin Bunsch"]
    gem.bindir = 'bin'
    gem.executables = ['bin/quick_serve', 'bin/qs']
    gem.default_executable = 'bin/qs'
      
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "quick_serve #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
