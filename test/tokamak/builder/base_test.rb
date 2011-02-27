require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Tokamak::Builder::BaseTest < Test::Unit::TestCase

  class SomeBuilder < Tokamak::Builder::Base
    def self.media_types
      ["valid/media_type"]
    end
  end

  class AnotherBuilder < Tokamak::Builder::Base
    def self.media_types
      ["valid/media_type", "another_valid/media_type"]
    end
  end

  class YetAnotherBuilder < Tokamak::Builder::Base
    def self.media_types
      ["yet_another_valid/media_type"]
    end
  end
  
  def setup
    @registry = Tokamak::Registry.new
    @registry << SomeBuilder
    @registry << AnotherBuilder
    @registry << YetAnotherBuilder
  end

  def test_should_lookup_valid_media_types
    assert_equal AnotherBuilder   , @registry["valid/media_type"]
    assert_equal AnotherBuilder   , @registry["another_valid/media_type"]
    assert_equal YetAnotherBuilder, @registry["yet_another_valid/media_type"]
  end
  
  def test_should_lookup_invalid_media_types
    assert_equal nil   , @registry["invalid/media_type"]
  end
  
end
