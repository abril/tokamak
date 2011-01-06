module Tokamak
  module Builder
    require "tokamak/builder/base"
    require "tokamak/builder/values"
    require "tokamak/builder/json"
    require "tokamak/builder/xml"

    def self.helper_module_for(const)
      mod = Module.new
      mod.module_eval <<-EOS
        def collection(obj, *args, &block)
          #{const.name}.build(obj, *args, &block)
        end

        alias_method :member, :collection
      EOS
      mod
    end
  end
end
