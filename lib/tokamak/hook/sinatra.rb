require File.expand_path(File.dirname(__FILE__) + '/../../tokamak.rb') unless defined? ::Tokamak
require "tokamak/hook/tilt"

module Rack
  class Tokamak
    
    def initialize(app)
      @app = app
      @registry = ::Tokamak::Registry.new
      if block_given?
        yield @registry
      else
        @registry << ::Tokamak::Builder::Json
        @registry << ::Tokamak::Builder::Xml
      end
    end
    
    def call(env)
      env["tokamak"] = @registry
      @app.call(env)
    end
    
  end
end

module Tokamak
  module Hook
    module Sinatra

      module ::Sinatra::Templates

        def tokamak(template, options={}, locals={})
          options.merge! :layout => false, :media_type => response["Content-Type"]
          render :tokamak, template, options, locals
        end

      end
    end
  end
end
