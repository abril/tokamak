require 'test_helper'

class Tokamak::Builder::BaseTest < Test::Unit::TestCase

  class SomeBuilder < Tokamak::Builder::Base
    builder_for "valid/media_type"
  end

  class AnotherBuilder < Tokamak::Builder::Base
    builder_for "valid/media_type", "another_valid/media_type"
  end

  class YetAnotherBuilder < Tokamak::Builder::Base
    builder_for "yet_another_valid/media_type"
  end

  def test_should_support_media_type_registering
    assert_equal ["valid/media_type"]                           , SomeBuilder.media_types
    assert_equal ["valid/media_type","another_valid/media_type"], AnotherBuilder.media_types
    
    AnotherBuilder.add_media_type "awesome/media_type"
    
    assert_equal ["valid/media_type","another_valid/media_type","awesome/media_type"], AnotherBuilder.media_types
    assert_equal AnotherBuilder                                                      , Tokamak.builder_lookup("awesome/media_type")
  end

  def test_builder_lookup
    assert_equal AnotherBuilder   , Tokamak.builder_lookup("valid/media_type")
    assert_equal AnotherBuilder   , Tokamak.builder_lookup("another_valid/media_type")
    assert_equal YetAnotherBuilder, Tokamak.builder_lookup("yet_another_valid/media_type")
  end
    
end
