require 'test_helper'

class TestSilk < Test::Unit::TestCase
  context 'TestSilk' do
    context 'run' do
      should 'use SyslogLogger' do
        logger_mock = mock
        options = { :ontop => false }
        Options.stubs(:parse).returns(options)
        Daemons.stubs(:call).with(options)
        SyslogLogger.expects(:new).with('silk').returns(logger_mock)
        Silk.run
        assert_equal logger_mock, options[:logger]
        assert_equal options, Silk.options
      end

      should 'use STDOUT for logging if ontop is true' do
        logger_mock = mock
        options = { :ontop => true }
        Options.stubs(:parse).returns(options)
        Daemons.stubs(:call).with(options)
        Logger.expects(:new).with(STDOUT).returns(logger_mock)
        Silk.run
        assert_equal logger_mock, options[:logger]
        assert_equal options, Silk.options
      end

      should 'change the directory in the child to match the parent' do
        logger_mock = mock
        options = { :ontop => true, :multiple => true, :bind => '1.2.3.4', :port => 80 }
        Options.stubs(:parse).returns(options)
        Logger.stubs(:new).returns(logger_mock)
        Dir.expects(:pwd).returns('/tmp/dir')
        Dir.expects(:chdir).with('/tmp/dir')
        Silk::Server.stubs(:run!)
        Silk.run
      end

      should 'should start the webserver with the supplied options' do
        logger_mock = mock
        options = { :ontop => true, :multiple => true, :bind => '1.2.3.4', :port => 80 }
        Options.stubs(:parse).returns(options)
        Logger.stubs(:new).returns(logger_mock)
        Silk::Server.expects(:run!).with({ :host => '1.2.3.4', :port => 80, :environment => :production })
        Silk.run
      end
    end
  end
end
