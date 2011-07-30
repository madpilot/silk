require 'json'
require 'sinatra/base'

module Silk
  class Server < Sinatra::Base
    def process(context, params)
      options = Silk.options
      task = nil
      format = 'text'
      
      query = context.split('.')
      format = query.pop if query.size > 1
      task = query.join('.').gsub("/", ":")
     
      case(format)
      when 'json'
        content_type('application/json')
      when 'xml'
        content_type('application/xml')
      else
        content_type('text/plain')
      end
      
      ENV['format'] = format
 
      begin
        results = Runner.execute(task, params)
        headers('X_PROCESS_EXIT_STATUS' => results[:status].exitstatus.to_s)
       
        if results[:status].exitstatus != 0
          error(500, results[:stderr])
        else
          results[:stdout]
        end
      
      rescue Silk::Exceptions::TaskNotFound
        not_found("Not found")
      end
    end

    get %r{\/(.+)} do |context|
      process context, params
    end

    post %r{\/(.+)} do |context|
      process context, params
    end
    
    put %r{\/(.+)} do |context|
      process context, params
    end
    
    delete %r{\/(.+)} do |context|
      process context, params
    end

    not_found do
      'Not found'
    end
  end
end
