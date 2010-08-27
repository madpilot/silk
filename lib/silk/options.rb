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
        exit(-1)
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
      opts.on('-b', '--bind', /.+/, 'Set the IP address to listen to') do |host|
        options[:bind] = host
      end

      options[:server] = %w[thin mongrel webrick]
      opts.on('-s', '--server', /.+/, 'handler used for built-in web server') do |server|
        options[:server] = server
      end
 
      opts.on('-v', '--version') do
        File.open(File.join(File.dirname(__FILE__), '..', '..', 'VERSION')) do |fh|
          puts fh.read
        end
        exit(0)
      end
    end
 
    begin
      optparse.parse!
      options
    rescue OptionParser::InvalidOption => e
      puts optparse
      exit(-1)
    end
  end
end
