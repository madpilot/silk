require 'json'
require 'open3'
require 'sinatra/base'

module Silk
  class Server < Sinatra::Base
    get %r{\/(.+)} do |c|
      content_type('application/json')

      options = Silk.options
      task = c.gsub("/", ":")
      
      unless Silk::Tasks.list.include?(task)
        not_found("Not Found".to_json)
      end

      puts params.inspect

      stdout, stderr = '', ''
      results = { :stdout => '', :stderr => '' }

      cmd = [ 'rake', '-s' ]
      options[:filter_paths].each do |path|
        cmd += [ '-R', path ]
      end
      cmd << task

      Open3.popen3(cmd.join(' ')) do |i, o, e|
        results[:stdout] = o.read
        results[:stderr] = e.read
      end

      if results[:stderr] != ""
        error(500, results[:stderr])
      else
        results[:stdout]
      end
    end
  end
end
