require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Tokamak::RecipesTest < Test::Unit::TestCase

  def test_add_recipe_to_tokamak
    Tokamak::Recipes.add "foo" do
      string = "recipes are represented as blocks"
    end
    Tokamak::Recipes.add :bar do
      string = "recipes are represented as blocks"
    end

    assert_equal Proc, Tokamak::Recipes["foo"].class
    assert_equal Proc, Tokamak::Recipes[:bar].class
    assert_equal nil , Tokamak::Recipes["undeclared recipe"]
  end

  def test_remove_recipe_from_tokamak
    Tokamak::Recipes.add :bar do
      string = "recipes are represented as blocks"
    end
    Tokamak::Recipes.remove(:bar)

    assert_equal nil, Tokamak::Recipes[:bar]
  end

  def test_list_recipe_names
    Tokamak::Recipes.add "foo" do
      string = "recipes are represented as blocks"
    end
    Tokamak::Recipes.add :bar do
      string = "recipes are represented as blocks"
    end

    assert_equal 2, Tokamak::Recipes.list.size
    assert Tokamak::Recipes.list.include?(:bar)
    assert Tokamak::Recipes.list.include?("foo")
  end


end

