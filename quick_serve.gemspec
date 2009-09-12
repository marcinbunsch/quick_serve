# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{quick_serve}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcin Bunsch"]
  s.date = %q{2009-09-12}
  s.default_executable = %q{qs}
  s.description = %q{}
  s.email = %q{marcin@applicake.com}
  s.executables = ["quick_serve", "qs"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/qs",
     "bin/quick_serve",
     "lib/quick_serve.rb",
     "lib/quick_serve/server.rb",
     "lib/quick_serve/snapshot_handler.rb",
     "quick_serve.gemspec"
  ]
  s.homepage = %q{http://github.com/marcinbunsch/quick_serve}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Super simple web server mainly for javascript development}
  s.test_files = [
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
