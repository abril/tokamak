module Tokamak
  module Builder
    class Base

      class << self

        def build(obj, options = {}, &block)
          recipe = block_given? ? block : options.delete(:recipe)

          raise Tokamak::BuilderError.new("Recipe required to build representation.") unless recipe.respond_to?(:call)

          builder = self.new(obj, options)

          recipe.call(*[builder, obj, options][0, recipe.arity])

          builder.representation
        end

        def helper
          @helper_module ||= Tokamak::Builder.helper_module_for(self)
        end

        def collection_helper_default_options(options = {}, &block)
          generic_helper(:collection, options, &block)
        end

        def member_helper_default_options(type, options = {}, &block)
          generic_helper(:member, options, &block)
        end

        def generic_helper(section, options = {}, &block)
          helper.send(:remove_method, section)
          var_name = "@@more_options_#{section.to_s}".to_sym
          helper.send(:class_variable_set, var_name, options)
          helper.module_eval <<-EOS
            def #{section.to_s}(obj, *args, &block)
              #{var_name}.merge!(args.shift)
              args.unshift(#{var_name})
              #{self.name}.build(obj, *args, &block)
            end
          EOS
        end
      end

    end
  end
end
