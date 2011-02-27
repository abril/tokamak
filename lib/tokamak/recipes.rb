module Tokamak
  class Recipes

    def initialize
      @recipes = {}
    end

    def add(recipe_name, &block)
      @recipes[recipe_name] = block
    end

    def remove(recipe_name)
      @recipes.delete(recipe_name)
    end

    def [](recipe_name)
      @recipes[recipe_name]
    end

    def list
      @recipes.keys
    end

  end
end
