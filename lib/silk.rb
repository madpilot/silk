$:.unshift File.join(File.dirname(File.expand_path(__FILE__)), 'silk')

require 'rubygems'
require 'rake'
require 'syslog_logger'
require 'daemons'
require 'options'
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
    Server.run! :host => options[:bind], :port => options[:port], :environment => :production
  end

  def self.options
    @options
  end

  def self.options=(options)
    @options = options
  end
end
