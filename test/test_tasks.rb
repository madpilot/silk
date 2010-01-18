require 'test_helper'

class TestSilk < Test::Unit::TestCase
  context '' do
    setup do
      Silk.options = { :filter_paths => File.join(File.dirname(File.expand_path(__FILE__)), 'rakefiles') }
      @task = Silk::Tasks.new
    end

    should "return a list of all the available rake tasks" do
      assert @task.list.include?("level_1")
      assert @task.list.include?("level_1:level_2")
      assert @task.list.include?("level_1:level_2_with_args")
      assert @task.list.include?("level_1:level_2:level_3")
      assert @task.list.include?("errors:return")
    end

    should "run a task if it exists" do
      stdout_read, stdout_write = IO.pipe
      stderr_read, stderr_write = IO.pipe
      pid = Process.fork do
        $stdout.reopen stdout_write
        $stderr.reopen stderr_write
        stdout_read.close
        stderr_read.close
        @task.run("level_1")
      end
      
      stdout_write.close
      stderr_write.close

      stdout = ''
      stderr = ''
      stdout_read.each do |line|
        stdout += line
      end
      stderr_read.each do |line|
        stderr += line
      end
      Process.waitpid(pid)
 
      assert_equal "Level_1".to_json, stdout.strip
      assert_equal "".to_json, stderr.strip
    end

    should "run a task and pass in arrguments if it exists" do
      # I'm guessing this test fails because STDOUT and STDERR are already being captured
      stdout_read, stdout_write = IO.pipe
      stderr_read, stderr_write = IO.pipe
      pid = Process.fork do
        $stdout.reopen stdout_write
        $stderr.reopen stderr_write
        stdout_read.close
        stderr_read.close
        @task.run("level_2_with_args", { 'param_1' => '1' })
      end
      
      stdout_write.close
      stderr_write.close

      stdout = ''
      stderr = ''
      stdout_read.each do |line|
        stdout += line
      end
      stderr_read.each do |line|
        stderr += line
      end
      Process.waitpid(pid)
 
      assert_equal(("Level 2: " + { 'param_1' => '1' }.inspect).to_json, stdout.strip)
      assert_equal "".to_json, stderr.strip
    end

    should "run the task only once if a new Application is built"
  end
end
