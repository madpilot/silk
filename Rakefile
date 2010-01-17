require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "silk"
    gem.executables = "silk"
    gem.summary = %Q{A framework for creating a hosting console}
    gem.description = %Q{It allows you to write rake tasks to do common tasks, such as creating email addresses, adding users etc. Silk provides a HTTP wrapper the the rake tasks, and allows communication via JSON objects, which makes it dead easy for them to be called from a web app.}
    gem.email = "myles@madpilot.com.au"
    gem.homepage = "http://github.com/madpilot/silk"
    gem.authors = ["Myles Eftos"]
    
    gem.add_dependency 'daemons'
    gem.add_dependency 'open4'
    gem.add_dependency 'SyslogLogger'
    
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
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
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "silk #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
