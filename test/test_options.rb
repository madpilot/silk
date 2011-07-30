require 'test_helper'

class TestOptions < Test::Unit::TestCase
  context 'TestOptions' do
    setup do
      ENV['HOME'] = '/home/john'
      ARGV.delete_if { |el| true }
    end

    should 'set defaults' do
      options = Options.parse
      assert_equal false, options[:verbose]
      assert_equal false, options[:ontop]
      assert_equal [ '/etc/silk', '/home/john/.silk' ], options[:recipe_paths]
      assert_equal 8888, options[:port]
      assert_equal false, options[:lock]
      assert_equal '0.0.0.0', options[:bind]
      assert_equal [ 'thin', 'mongrel', 'webrick' ], options[:server]
    end

    should 'set verbose mode if -V is set' do
      ARGV << '-V'
      options = Options.parse
      assert_equal true, options[:verbose]
    end

    should 'set verbose mode if --verbose is set' do
      ARGV << '--verbose'
      options = Options.parse
      assert_equal true, options[:verbose]
    end

    should 'display help on -h' do
      ARGV << '-h'
      
      stdout_read, stdout_write = IO.pipe
      
      pid = Process.fork do
        $stdout.reopen stdout_write
        stdout_read.close
        options = Options.parse
      end
      
      stdout_write.close
      pid, status = Process.waitpid2(pid)
      assert_equal 1, status.exitstatus
    end

    should 'display help on --help' do
      ARGV << '--help'
      
      stdout_read, stdout_write = IO.pipe
      
      pid = Process.fork do
        $stdout.reopen stdout_write
        stdout_read.close
        options = Options.parse
      end
      
      stdout_write.close
      pid, status = Process.waitpid2(pid)
      assert_equal 1, status.exitstatus
    end

    should 'set ontop to true if -f' do
      ARGV << '-f'
      options = Options.parse
      assert_equal true, options[:ontop]
    end

    should 'set ontop to true if --foreground' do
      ARGV << '--foreground'
      options = Options.parse
      assert_equal true, options[:ontop]
    end

    should 'add recipes to the recipe list for each -r' do
      ARGV << '-r'
      ARGV << '/tmp/recipes'
      options = Options.parse
      assert_equal [ '/etc/silk', '/home/john/.silk', '/tmp/recipes' ], options[:recipe_paths]
      
      ARGV << '-r'
      ARGV << '/tmp/recipes'
      ARGV << '-r'
      ARGV << '/tmp/recipes_2'
      
      options = Options.parse
      assert_equal [ '/etc/silk', '/home/john/.silk', '/tmp/recipes', '/tmp/recipes_2' ], options[:recipe_paths]
    end

    should 'add recipes to the recipe list for each --recipes' do
      ARGV << '--recipes'
      ARGV << '/tmp/recipes'
      options = Options.parse
      assert_equal [ '/etc/silk', '/home/john/.silk', '/tmp/recipes' ], options[:recipe_paths]
      
      ARGV << '--recipes'
      ARGV << '/tmp/recipes'
      ARGV << '--recipes'
      ARGV << '/tmp/recipes_2'
      
      options = Options.parse
      assert_equal [ '/etc/silk', '/home/john/.silk', '/tmp/recipes', '/tmp/recipes_2' ], options[:recipe_paths]
    end

    should 'set port if -p is set' do
      ARGV << '-p'
      ARGV << '1234'
      options = Options.parse
      assert_equal 1234, options[:port]
    end

    should 'set port if --port is set' do
      ARGV << '--port'
      ARGV << '1234'
      options = Options.parse
      assert_equal 1234, options[:port]
    end

    should 'set lock if -x is set' do
      ARGV << '-x'
      options = Options.parse
      assert_equal true, options[:lock]
    end
    
    should 'set lock if --lock is set' do
      ARGV << '-x'
      options = Options.parse
      assert_equal true, options[:lock]
    end

    should 'set bind address if -b is set' do
      ARGV << '-b'
      ARGV << '1.2.3.4'
      options = Options.parse
      assert_equal '1.2.3.4', options[:bind]
    end
  
    should 'set bind address if --bind is set' do
      ARGV << '--bind'
      ARGV << '1.2.3.4'
      options = Options.parse
      assert_equal '1.2.3.4', options[:bind]
    end
   
    should 'set the server array if -s is set' do
      ARGV << '-s'
      ARGV << 'iis'
      options = Options.parse
      assert_equal [ 'iis' ], options[:server]
    end

    should 'set the server array if --server is set' do
      ARGV << '--server'
      ARGV << 'iis'
      options = Options.parse
      assert_equal [ 'iis' ], options[:server]
    end

    should 'set the test flag if -t is set' do
      ARGV << '-t'
      options = Options.parse
      assert options[:test]
    end

    should 'set the test flag if --test is set' do
      ARGV << '--test'
      ARGV << "test:task"
      options = Options.parse
      assert options[:test]
      assert_equal "test:task", options[:test_task]
    end

    should 'set the ontop flag if -t is set' do
      ARGV << '-t'
      ARGV << "test:task"
      options = Options.parse
      assert_equal true, options[:ontop]
      assert_equal "test:task", options[:test_task]
    end

    should 'set the optop flag if --test is set' do
      ARGV << '--test'
      options = Options.parse
      assert_equal true, options[:ontop]
    end
   
    should 'add params to the test_params array if --param is set' do
      ARGV << '--param'
      ARGV << 'user=joe'
      options = Options.parse
      assert_equal 'joe', options[:test_params]['user']
    end

    should 'add params to the test_params array if --paramaters is set' do
      ARGV << '--parameter'
      ARGV << 'user=joe'
      options = Options.parse
      assert_equal 'joe', options[:test_params]['user']
    end

    should 'set the format environment variable if --format is set' do
      ARGV << '--format'
      ARGV << 'json'
      options = Options.parse
      assert_equal 'json', ENV['format']
    end

    should 'display the VERSION of -v is set' do
      ARGV << '-v'
      
      stdout_read, stdout_write = IO.pipe
      
      pid = Process.fork do
        $stdout.reopen stdout_write
        stdout_read.close
        options = Options.parse
      end
     
      result = ''
      stdout_write.close
      stdout_read.each do |line|
        result += line
      end
      pid, status = Process.waitpid2(pid)
      assert_equal 1, status.exitstatus
      version = ''
      
      File.open(File.join(File.dirname(__FILE__), '..', 'VERSION')) do |fh|
        version = fh.read
      end
      assert_equal result, version
    end

    should 'display the VERSION of --version is set' do
      ARGV << '--version'
      
      stdout_read, stdout_write = IO.pipe
      
      pid = Process.fork do
        $stdout.reopen stdout_write
        stdout_read.close
        options = Options.parse
      end
     
      result = ''
      stdout_write.close
      stdout_read.each do |line|
        result += line
      end
      pid, status = Process.waitpid2(pid)
      assert_equal 1, status.exitstatus
      
      version = ''
      File.open(File.join(File.dirname(__FILE__), '..', 'VERSION')) do |fh|
        version = fh.read
      end
      assert_equal result, version
    end
  end
end
