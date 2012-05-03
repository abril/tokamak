require 'test_helper'

# every builder comes with a default helper, with collection and member methods. See lib/tokamak/builder.rb
class TestDefaultHelper
  extend Tokamak::Builder::Json.helper
end

# but here you can cheack how to pass other default options to helper methods
class DummyAtom < Tokamak::Builder::Base
  builder_for "application/atom+xml"

  collection_helper_default_options :atom_type => :feed
  member_helper_default_options     :atom_type => :entry
  
  def initialize(obj, options = {})
    #do nothing
  end
  
  def representation
    "puft!"
  end
end
class AtomGenerator
  extend DummyAtom.helper
end

# how to complete override the helper
module MyHelper
  # these examples are just to show that you can freely change the behavior 
  # of the helper methods, since you respect the methods signature
  def collection(obj, *args, &block)
    member(obj, *args, &block)
  end

  def member(obj, *args, &block)
    default_options = {:my_option => "my_value"}
    default_options.merge!(args.shift)
    args.unshift(default_options)
    OverwrittenHelperBuilder.build(obj, *args, &block)
  end
end
class OverwrittenHelperBuilder < Tokamak::Builder::Base
  builder_for "some/media+type"

  # just implement this method passing the new helper
  def self.helper
    MyHelper
  end
  
  def initialize(obj, options = {})
    #do nothing
  end
  
  def representation
    "pleft!"
  end
end
class TestOverwrittenHelper
  extend OverwrittenHelperBuilder.helper
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

  def test_helper_with_options_overwritten
    numbers = [1,2,3,4,5]
    result = AtomGenerator.collection(numbers, :other_option => "an_option") do |collection, num, opt|
      assert_equal :feed      , opt[:atom_type]
      assert_equal "an_option", opt[:other_option]
      assert_equal [1,2,3,4,5], num
    end
    assert_equal "puft!", result
  end
  
  def test_overwritten_helper
    numbers = [1,2,3,4,5]
    result = TestOverwrittenHelper.collection(numbers, :other_option => "an_option") do |collection, num, opt|
      assert_equal "an_option", opt[:other_option]
      assert_equal "my_value" , opt[:my_option]
      assert_equal [1,2,3,4,5], num
    end
    assert_equal "pleft!", result
  end
end

