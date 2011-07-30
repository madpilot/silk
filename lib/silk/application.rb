module Silk
  class Application < Silk::Server
    set :logging, Proc.new { ! test? }
    set :method_override, true
    set :run, Proc.new { ! test? }
    set :session_secret, Proc.new { super() unless development? }
    set :app_file, nil

    def self.register(*extensions, &block) #:nodoc:
      added_methods = extensions.map {|m| m.public_instance_methods }.flatten
      Sinatra::Delegator.delegate(*added_methods)
      super(*extensions, &block)
    end
  end
end
