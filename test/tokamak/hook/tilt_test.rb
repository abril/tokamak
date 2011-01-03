require 'test/unit'
require 'rubygems'
require 'ruby-debug'
require "methodize"
require "tilt"

require "tokamak/hook/tilt"

class Tokamak::Hook::TiltTest < Test::Unit::TestCase

  def test_tokamak_builder_integration_with_tilt
    @some_articles = [
      {:id => 1, :title => "a great article", :updated => Time.now},
      {:id => 2, :title => "another great article", :updated => Time.now}
    ]

    template = Tokamak::Hook::Tilt::TokamakTemplate.new(File.expand_path(File.dirname(__FILE__) + '/../../rails2_skel/app/views/test/show.tokamak'), :content_type => "application/json")
    json     = template.render(self, :@some_articles => @some_articles)
    hash     = JSON.parse(json).extend(Methodize)

    assert_equal "John Doe"               , hash.author.first.name
    assert_equal "foobar@example.com"     , hash.author.last.email
    assert_equal "http://example.com/json", hash.id

    assert_equal "http://a.link.com/next" , hash.link.first.href
    assert_equal "next"                   , hash.link.first.rel
    assert_equal "application/json"       , hash.link.last.type

    assert_equal "uri:1"                      , hash.articles.first.id
    assert_equal "a great article"            , hash.articles.first.title
    assert_equal "http://example.com/image/1" , hash.articles.last.link.first.href
    assert_equal "image"                      , hash.articles.last.link.first.rel
    assert_equal "application/json"           , hash.articles.last.link.last.type
  end
end
