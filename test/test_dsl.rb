require 'test_helper'

# Need some helper classes so we can call the methods defined in the rake include file
eval <<-EOF
  module Silk
    module DSL
      #{File.read(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'silk', 'dsl.rake')))}
    end
  end
EOF

class FakeRake
  include Silk::DSL
end

class TestDSL < Test::Unit::TestCase
  context 'TestDSL' do
    setup do
      @context = FakeRake.new
    end

    context 'ProcessResult' do
      setup do
        @result = Silk::DSL::ProcessResult.new('Standard Output', 'Standard Error', 0)
      end

      context 'to_xml' do
        should 'return an XML representation of the object'
      end

      context 'to_json' do
        should 'return an JSON respresentation of the object' do
          obj = JSON::parse(@result.to_json)
          assert_equal 'Standard Output', obj['stdout']
          assert_equal 'Standard Error', obj['stderr']
          assert_equal 0, obj['exitstatus']
        end
      end

      context 'to_s' do
        should 'return stdout if defined' do
          assert_equal 'Standard Output', @result.to_s
        end
        
        should 'return stderr if stdout if not defined' do
          @result.stdout = nil
          assert_equal 'Standard Error', @result.to_s
        end
      end
    end

    context 'respond_to' do
      should 'call the text block if ENV[format] == text' do
        ENV['format'] = 'text'

        stdout_read, stdout_write = IO.pipe
        pid = Process.fork do
          $stdout.reopen stdout_write
          stdout_read.close
          
          @context.respond_to do |format|
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
          
          @context.respond_to do |format|
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
          
          @context.respond_to do |format|
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
          
          @context.error_respond_to do |format|
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
          
          
          @context.error_respond_to do |format|
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
          
          @context.error_respond_to do |format|
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

    context 'run' do
      should 'capture standard input and return a ProcessResult object' do
        result = @context.run File.join(File.dirname(__FILE__), '..', 'test', 'bin', 'successful')
        assert_equal Silk::DSL::ProcessResult, result.class
      end

      should 'set the stdout value' do
        result = @context.run File.join(File.dirname(__FILE__), '..', 'test', 'bin', 'successful')
        assert_equal 'Success!', result.stdout.strip
      end
      
      should 'set the stderr value' do
        result = @context.run File.join(File.dirname(__FILE__), '..', 'test', 'bin', 'failure')
        assert_equal 'Fail :(', result.stderr.strip
      end
      
      should 'set the exitstatus value' do
        result = @context.run File.join(File.dirname(__FILE__), '..', 'test', 'bin', 'failure')
        assert_equal 1, result.exitstatus
      end
    end
  end
end
