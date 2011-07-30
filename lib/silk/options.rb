require 'optparse'
 
class Options
  def self.parse
    options = {
      :multiple => false
    }
 
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: #{opts.program_name} [options]"
 
      options[:verbose] = false
      opts.on('-V', '--verbose', 'Be more verbose') do
        options[:verbose] = true
      end
 
      opts.on('-h', '--help', "You're looking at it") do
        puts opts
        exit(1)
      end
 
      options[:ontop] = false
      opts.on('-f', '--foreground', "Run in the foreground") do
        options[:ontop] = true
      end
 
      options[:recipe_paths] = [ File.join('', 'etc', 'silk') ] 
      options[:recipe_paths] << File.join(ENV['HOME'], '.silk') if ENV['HOME']
      
      opts.on('-r [recipe]', '--recipes [recipe]', /.+/, 'Reads in additional recipes') do |recipes|
        options[:recipe_paths] << recipes
      end
 
      options[:port] = 8888
      opts.on('-p [port]', '--port', /\d+/, 'Port to run the server on (Default: 8888)') do |port|
        options[:port] = port.to_i
      end

      options[:lock] = false
      opts.on('-x', '--lock', 'Set a mutex lock') do
        options[:lock] = true
      end

      options[:bind] = '0.0.0.0'
      opts.on('-b [address]', '--bind', /.+/, 'Set the IP address to listen to') do |host|
        options[:bind] = host
      end

      options[:server] = %w[thin mongrel webrick]
      opts.on('-s [server list]', '--server', /.+/, 'handler used for built-in web server') do |server|
        options[:server] = [ server ]
      end

      options[:test] = false
      options[:test_task] = nil
      opts.on('-t [task]', '--test', /.+/, 'Test the supplied rake task on the command line') do |test|
        options[:test] = true
        options[:test_task] = test
        options[:ontop] = true
      end

      options[:test_params] = {}
      opts.on('--param [param]', '--parameter', /.+/, 'Parameters to pass in to the test task. Enter as key/value pairs, ie user=joe') do |param|
        k, v = param.split('=')
        options[:test_params][k] = v
      end

      opts.on('--format [format]', /.+/, 'Output format') do |format|
        ENV['format'] = format
      end

      opts.on('-v', '--version') do
        File.open(File.join(File.dirname(__FILE__), '..', '..', 'VERSION')) do |fh|
          puts fh.read
        end
        exit(1)
      end
    end
 
    begin
      optparse.parse!
      options
    rescue OptionParser::InvalidOption => e
      puts optparse
      exit(1)
    end
  end
end
