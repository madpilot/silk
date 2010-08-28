require 'rake'

module Silk
  class Tasks
    def initialize
      Rake::Task.clear
      @app = Rake::Application.new
      @app.init
      @app.rake_require 'dsl'
      
      Silk.options[:recipe_paths].each do |path|
        FileList.new("#{path}/*.rake").each do |file|
          @app.add_import(file)
        end
      end
      @app.load_rakefile
    end

    def list
      return Rake::Task.tasks.map { |task| task.name }
    end

    def run(task, arguments = {})
      task = Rake::Task[task]
      task.execute(arguments)
    end
  end
end
