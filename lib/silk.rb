$:.unshift File.join(File.dirname(File.expand_path(__FILE__)), 'silk')

require 'rubygems'
require 'rake'
require 'syslog_logger'
require 'daemons'
require 'options'
require 'runner'
require 'exceptions/task_not_found'
require 'server'
require 'tasks'

module Silk
  def self.run
    options = Options.parse

    if options[:ontop]
      options[:logger] = Logger.new(STDOUT)
    else
      options[:logger] = SyslogLogger.new('silk')
    end
    
    Silk.options = options

    old_proc_name = $0
    pwd = Dir.pwd
    Daemons.call(options) do
      $0 = old_proc_name
      Dir.chdir pwd
      if options[:test]
        puts Runner.test(options[:test_task], options[:test_params]) 
      else
        Server.run! :host => options[:bind], :port => options[:port], :environment => :production
      end
    end
  end

  def self.options
    @options
  end

  def self.options=(options)
    @options = options
  end
end
