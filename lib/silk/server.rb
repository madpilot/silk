require 'json'
require 'sinatra/base'

module Silk
  class Server < Sinatra::Base
    get %r{\/(.+)} do |c|
      options = Silk.options
      task = nil
      format = 'text'
      
      query = c.split('.')
      format = query.pop if query.size > 1
      task = query.join('.').gsub("/", ":")
     
      case(format)
      when 'json'
        content_type('application/json')
      when 'xml'
        content_type('application/xml')
      else
        content_type('text/plain')
      end

      tasks = Silk::Tasks.new
      unless tasks.list.include?(task)
        not_found("Not Found")
      end

      results = { :stdout => '', :stderr => '' }
      params.delete("captures")
      ENV['format'] = format

      stdout_read, stdout_write = IO.pipe
      stderr_read, stderr_write = IO.pipe
      pid = Process.fork do
        $stdout.reopen stdout_write
        $stderr.reopen stderr_write
        stdout_read.close
        stderr_read.close
        tasks.run(task, params)
      end
      
      stdout_write.close
      stderr_write.close
      stdout_read.each do |line|
        results[:stdout] += line
      end
      stderr_read.each do |line|
        results[:stderr] += line
      end
      pid, status = Process.waitpid2(pid)
    
      headers('X_PROCESS_EXIT_STATUS' => status.exitstatus.to_s)
     
      if status.exitstatus != 0
        error(500, results[:stderr].strip)
      else
        results[:stdout].strip
      end
    end

    not_found do
      'Not found'
    end
  end
end
