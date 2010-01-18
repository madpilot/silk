require 'json'

desc "Level 1"
task :level_1 do
  puts "Level 1".to_json
end

namespace :level_1 do
  desc "Level 2" 
  task :level_2 do
    puts "Level 2".to_json
  end

  desc "Level 2 with args" 
  task :level_2_with_args do |t, args|
    puts(("Level 2: " + args.inspect).to_json)
  end

  namespace :level_2 do
    task :level_3 do
      puts "Level 3".to_json
    end
  end
end

namespace :errors do
  desc "Returns an error"
  task :return do
    $stderr.puts "Error".to_json
    exit(-1)
  end
end
