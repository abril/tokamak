module Tokamak
  module Builder
    class Base

      @@global_media_types = {}

      class << self
        def builder_for(*args)
          # class instance variable to store media types handled by a builder
          @media_types = args
          args.each do |media_type|
            @@global_media_types[media_type] = self
          end
        end

        def media_types
          @media_types
        end

        def global_media_types
          @@global_media_types
        end

        def build(obj, options = {}, &block)
          if block_given?
            recipe = block
          else
            recipe = options.delete(:recipe)
          end

          if !recipe.respond_to?(:call)
            recipe = Tokamak::Recipes[recipe]
            raise Tokamak::BuilderError.new("Recipe required to build representation.") unless recipe
          end

          builder = self.new(obj, options)

          if recipe.arity==-1
            builder.instance_exec(&recipe)
          else
            recipe.call(*[builder, obj, options][0, recipe.arity])
          end

          builder.representation
        end

        def helper
          unless instance_variable_get(:@helper_module)
            @helper_module = Tokamak::Builder.helper_module_for(self)
          end
          @helper_module
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

      def method_missing(sym, *args, &block)
        values do |v|
          v.send sym, *args, &block
        end
      end
      
      def write(sym, val)
        values do |v|
          v.send sym, val
        end
      end
      
      # the members method is left for compatibility with the
      # external scope version of the DSL
      def each(*args, &block)
        members(*args, &block)
      end

    end
  end
end
