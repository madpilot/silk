module Silk
  class Runner
    def self.execute(task, params)
      tasks = Silk::Tasks.new
      raise Silk::Exceptions::TaskNotFound unless tasks.list.include?(task)

      results = { :stdout => '', :stderr => '', :status => nil }
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
      
      pid, status = Process.waitpid2(pid)
      results[:status] = status
      results[:stdout].strip!
      results[:stderr].strip!
      
      return results
    end

    def self.test(task, params)
      results = self.execute(task, params)

      if results[:status].exitstatus != 0
        "Error: #{results[:stderr]}"
      else
        "Success: #{results[:stdout]}"
      end
    end
  end
end
