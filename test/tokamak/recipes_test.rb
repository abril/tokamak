require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Tokamak::RecipesTest < Test::Unit::TestCase
  
  def setup
    @recipes = Tokamak::Recipes.new
  end

  def test_add_recipe_to_tokamak
    @recipes.add "foo" do
      string = "recipes are represented as blocks"
    end
    @recipes.add :bar do
      string = "recipes are represented as blocks"
    end

    assert_equal Proc, @recipes["foo"].class
    assert_equal Proc, @recipes[:bar].class
    assert_equal nil , @recipes["undeclared recipe"]
  end

  def test_remove_recipe_from_tokamak
    @recipes.add :bar do
      string = "recipes are represented as blocks"
    end
    @recipes.remove(:bar)

    assert_equal nil, @recipes[:bar]
  end

  def test_list_recipe_names
    @recipes.add "foo" do
      string = "recipes are represented as blocks"
    end
    @recipes.add :bar do
      string = "recipes are represented as blocks"
    end

    assert @recipes.list.include?(:bar)
    assert @recipes.list.include?("foo")
  end

  def test_builder_with_previously_declared_recipe
    obj = [{ :foo => "bar" }]

    @recipes.add :simple_feed do |collection|
      collection.values do |values|
        values.id "an_id"
      end

      collection.members do |member, some_foos|
        member.values do |values|
          values.id some_foos[:foo]
        end
      end
    end

    json = Tokamak::Builder::Json.build(obj, :recipe => @recipes[:simple_feed])
    hash = JSON.parse(json).extend(Methodize)

    assert_equal "an_id", hash.id
    assert_equal "bar"  , hash.members.first.id
  end

  def test_raise_exception_with_a_undeclared_recipe
    obj = [{ :foo => "bar" }]

    assert_raise Tokamak::BuilderError do
      json = Tokamak::Builder::Json.build(obj, :recipe => nil)
    end
  end

  def test_builder_with_recipe_option_as_a_block
    obj = [{ :foo => "bar" }]

    json = Tokamak::Builder::Json.build(obj, :recipe => Proc.new { |collection|
      collection.values do |values|
        values.id "an_id"
      end

      collection.members do |member, some_foos|
        member.values do |values|
          values.id some_foos[:foo]
        end
      end
    })
    hash = JSON.parse(json).extend(Methodize)

    assert_equal "an_id", hash.id
    assert_equal "bar"  , hash.members.first.id
  end

end

