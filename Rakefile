# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # dependencies defined in Gemfile
  gem.name = "silk"
  gem.executables = "silk"
  gem.summary = %Q{A framework for creating a hosting console}
  gem.description = %Q{It allows you to write rake tasks to do common tasks, such as creating email addresses, adding users etc. Silk provides a HTTP wrapper the the rake tasks, and allows communication via JSON objects, which makes it dead easy for them to be called from a web app.}
  gem.email = "myles@madpilot.com.au"
  gem.homepage = "http://github.com/madpilot/silk"
  gem.authors = ["Myles Eftos"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "silk #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
