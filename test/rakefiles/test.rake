require 'json'

desc "Level 1"
task :level_1 do
  puts "Level 1"
end

namespace :level_1 do
  desc "Level 2" 
  task :level_2 do
    respond_to do |format|
      format.text { "text" }
      format.xml { "<xml>xml</xml>" }
      format.json { "json".to_json }
    end
  end

  desc "Level 2 with args" 
  task :level_2_with_args do |t, args|
    puts(("Level 2: " + args.inspect))
  end

  namespace :level_2 do
    task :level_3 do
      puts "Level 3"
    end
  end
end

namespace :errors do
  desc "Returns an error"
  task :return do
    $stderr.puts "Error"
    exit(1)
  end
end
