require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class OverrideWithOptionsBuilder < Tokamak::Builder::Base
  builder_for "application/atom+xml"

  collection_helper :options, :atom_type => :feed
  member_helper     :options, :atom_type => :entry
end

class OverrideWithMethodsBuilder < Tokamak::Builder::Base
  builder_for "application/atom+xml"

  collection_helper :method do |obj, *args, &block|
    self.build(obj, *args, &block)
  end
  member_helper     :method do |obj, *args, &block|
    self.build(obj, *args, &block)
  end
end

class TestDefaultHelper
  extend Tokamak::Builder::Json.helper
end

class TestHelperOverrideWithOptions
  extend OverrideWithOptionsBuilder.helper
end

class TestHelperOverrideWithMethods
  extend OverrideWithMethodsBuilder.helper
end

class Tokamak::Builder::HelperTest < Test::Unit::TestCase

  def test_default_helper
    obj = { :foo => "bar" }
    a_collection = [1,2,3,4]
    json = TestDefaultHelper.collection(obj) do |collection|
      collection.values do |values|
        values.id "an_id"
      end

      collection.members(:collection => a_collection) do |member, number|
        member.values do |values|
          values.id number
        end
      end
    end

    hash = JSON.parse(json).extend(Methodize)

    assert_equal "an_id", hash.id
    assert_equal 1      , hash.members.first.id
    assert_equal 4      , hash.members.size
  end

  def test_helper_with_options_overriden
    numbers = [1,2,3,4,5]
    result = TestHelperOverrideWithOptions.collection(numbers, :other_option => "an_option") do |collection, num, opt|
      assert_equal :feed      , opt[:atom_type]
      assert_equal "an_option", opt[:other_option]
      assert_equal [1,2,3,4,5], num
    end
  end
end

