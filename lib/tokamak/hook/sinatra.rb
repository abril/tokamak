require File.expand_path(File.dirname(__FILE__) + '/../../tokamak.rb') unless defined? ::Tokamak
require "tokamak/hook/tilt"

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
