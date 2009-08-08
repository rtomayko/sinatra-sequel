Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.name = 'sinatra-sequel'
  s.version = '0.9.0'
  s.date = '2009-08-08'

  s.description = "Extends Sinatra with Sequel ORM config, migrations, and helpers"
  s.summary = s.description

  s.authors = ["Ryan Tomayko"]
  s.email = "rtomayko@gmail.com"

  # = MANIFEST =
  s.files = %w[
    COPYING
    README.md
    Rakefile
    lib/sinatra/sequel.rb
    sinatra-sequel.gemspec
    spec/spec_sinatra_sequel.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select {|path| path =~ /^spec\/.*.rb/ }

  s.extra_rdoc_files = %w[README.md COPYING]
  s.add_dependency 'sinatra',    '>= 0.9.4'
  s.add_dependency 'sequel',     '>= 3.2.0'
  s.add_development_dependency 'bacon'

  s.has_rdoc = true
  s.homepage = "http://github.com/rtomayko/sinatra-sequel"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sinatra::Sequel"]
  s.require_paths = %w[lib]
  s.rubyforge_project = 'wink'
  s.rubygems_version = '1.1.1'
end
