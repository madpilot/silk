require 'test_helper'

class TestDSL < Test::Unit::TestCase
  context 'TestDSL' do
    context 'respond_to' do
      should 'call the text block if ENV[format] == text' do
        ENV['format'] = 'text'

        stdout_read, stdout_write = IO.pipe
        pid = Process.fork do
          $stdout.reopen stdout_write
          stdout_read.close
          
          respond_to do |format|
            format.text { 'text' }
            format.json { 'json'.to_json }
            format.xml { '<xml>xml</xml>' }
          end
        end
        stdout_write.close
        
        stdout = ''
        stdout_read.each do |line|
          stdout += line
        end
        Process.waitpid(pid)
        assert_equal 'text', stdout.strip
      end

      should 'call the text block if ENV[format] == xml' do
        ENV['format'] = 'xml'

        stdout_read, stdout_write = IO.pipe
        pid = Process.fork do
          $stdout.reopen stdout_write
          stdout_read.close
          
          respond_to do |format|
            format.text { 'text' }
            format.json { 'json'.to_json }
            format.xml { '<xml>xml</xml>' }
          end
        end
        stdout_write.close
        
        stdout = ''
        stdout_read.each do |line|
          stdout += line
        end
        Process.waitpid(pid)
        assert_equal '<xml>xml</xml>', stdout.strip
      end

      should 'call the text block if ENV[format] == json' do
        ENV['format'] = 'json'

        stdout_read, stdout_write = IO.pipe
        pid = Process.fork do
          $stdout.reopen stdout_write
          stdout_read.close
          
          respond_to do |format|
            format.text { 'text' }
            format.json { 'json'.to_json }
            format.xml { '<xml>xml</xml>' }
          end
        end
        stdout_write.close
        
        stdout = ''
        stdout_read.each do |line|
          stdout += line
        end
        Process.waitpid(pid)
        assert_equal 'json'.to_json, stdout.strip
      end
    end

    context 'error_respond_to' do
      should 'call the text block if ENV[format] == text' do
        ENV['format'] = 'text'

        stderr_read, stderr_write = IO.pipe
        pid = Process.fork do
          $stderr.reopen stderr_write
          stderr_read.close
          
          error_respond_to do |format|
            format.text { 'text' }
            format.json { 'json'.to_json }
            format.xml { '<xml>xml</xml>' }
          end
        end
        stderr_write.close
        
        stderr = ''
        stderr_read.each do |line|
          stderr += line
        end
        Process.waitpid(pid)
        assert_equal 'text', stderr.strip
      end

      should 'call the text block if ENV[format] == xml' do
        ENV['format'] = 'xml'

        stderr_read, stderr_write = IO.pipe
        pid = Process.fork do
          $stderr.reopen stderr_write
          stderr_read.close
          
          error_respond_to do |format|
            format.text { 'text' }
            format.json { 'json'.to_json }
            format.xml { '<xml>xml</xml>' }
          end
        end
        stderr_write.close
        
        stderr = ''
        stderr_read.each do |line|
          stderr += line
        end
        Process.waitpid(pid)
        assert_equal '<xml>xml</xml>', stderr.strip
      end

      should 'call the text block if ENV[format] == json' do
        ENV['format'] = 'json'

        stderr_read, stderr_write = IO.pipe
        pid = Process.fork do
          $stderr.reopen stderr_write
          stderr_read.close
          
          error_respond_to do |format|
            format.text { 'text' }
            format.json { 'json'.to_json }
            format.xml { '<xml>xml</xml>' }
          end
        end
        stderr_write.close
        
        stderr = ''
        stderr_read.each do |line|
          stderr += line
        end
        Process.waitpid(pid)
        assert_equal 'json'.to_json, stderr.strip
      end
    end
  end
end
