require 'json'
require 'sinatra/base'

module Silk
  class Server < Sinatra::Base
    get %r{\/(.+)} do |c|
      content_type('application/json')

      options = Silk.options
      task = c.gsub("/", ":")
      
      tasks = Silk::Tasks.new
      unless tasks.list.include?(task)
        not_found("Not Found".to_json)
      end

      results = { :stdout => '', :stderr => '' }
      params.delete("captures")
      
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
      Process.waitpid(pid)
    
      headers('X_PROCESS_EXIT_STATUS' => $?.exitstatus.to_s)
      
      if $?.exitstatus != 0
        error(500, results[:stderr].strip)
      else
        results[:stdout].strip
      end
    end
  end
end
