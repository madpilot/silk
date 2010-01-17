require 'rake'

module Silk
  class Tasks
    def self.list
      app = Rake::Application.new
      app.init
      Silk.options[:filter_paths].each do |path|
        FileList.new("#{path}/*.rake").each do |file|
          app.add_import(file)
        end
      end
      app.load_rakefile
      return Rake::Task.tasks.map { |task| task.name }
    end
  end
end
