module Tokamak
  module Builder
    class Base

      @@global_media_types = {}

      # class instance variable to store media types handled by a builder
      @media_types = []

      class << self
        def builder_for(*args)
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

        def build(obj = nil, options = {}, &block)
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

          recipe.call(*[builder, obj, options][0, recipe.arity])

          builder.representation
        end
      end

    end
  end
end
