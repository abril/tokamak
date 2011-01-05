module Tokamak
  module Builder
    autoload :Base  , "tokamak/builder/base"
    autoload :Values, "tokamak/builder/values"
    autoload :Json  , "tokamak/builder/json"
    autoload :Xml   , "tokamak/builder/xml"

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
