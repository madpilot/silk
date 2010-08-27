require 'fileutils'

class FileExists < StandardError;end

# Create the default recipe container for the gem
def write_to(path)
  if !File.exists?(path)
    FileUtils.mkdir_p(path)
  else
    raise FileExists.new("#{path} already exists")
  end
end

begin
  write_to('/etc/silk')
  exit(0)
rescue FileExists => e
  puts e
  exit(0)
rescue 
  # Just drop through...
end

begin
  write_to(File.join(ENV['HOME'], '.silk'))
rescue => e
  puts e
  exit(-1)
end
