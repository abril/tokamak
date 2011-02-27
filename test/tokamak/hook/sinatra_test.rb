require 'test/unit'
require 'rubygems'
require "methodize"
require "sinatra"
require "rack/conneg"

begin
  require 'ruby-debug'
rescue Exception => e; end

# requiring the hook for sinatra
require "tokamak/hook/sinatra"

# simple sinatra app declaration
set :views, File.expand_path(File.dirname(__FILE__) + '/../../rails2_skel/app/views/test')

use(Rack::Tokamak)
use(Rack::Conneg) do |conneg|
  conneg.set :accept_all_extensions, false
  conneg.set :fallback, :html
  conneg.ignore('/public/')
  conneg.provide([:json,:xml])
end

before do
  if negotiated?
    content_type negotiated_type
  end
end

get "/" do
  some_articles = [
    {:id => 1, :title => "a great article", :updated => Time.now},
    {:id => 2, :title => "another great article", :updated => Time.now}
  ]
  tokamak :show, {}, {:@some_articles => some_articles}
end

require "rack/test"
ENV['RACK_ENV'] = 'test'

class Tokamak::Hook::SinatraTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_tokamak_builder_hook_with_sinatra_rendering_json
    get '/', {}, {"HTTP_ACCEPT" => "application/json"}

    assert last_response.ok?
    hash     = JSON.parse(last_response.body).extend(Methodize)

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

  def test_tokamak_builder_hook_with_sinatra_rendering_xml
    get '/', {}, {"HTTP_ACCEPT" => "application/xml"}

    xml = Nokogiri::XML::Document.parse(last_response.body)

    assert_equal "John Doe"               , xml.css("root > author").first.css("name").first.text
    assert_equal "foobar@example.com"     , xml.css("root > author").last.css("email").first.text

    assert_equal "http://a.link.com/next" , xml.css("root > link").first["href"]
    assert_equal "next"                   , xml.css("root > link").first["rel"]
    assert_equal "application/xml"        , xml.css("root > link").last["type"]

    assert_equal "uri:1"                      , xml.css("root > articles").first.css("id").first.text
    assert_equal "a great article"            , xml.css("root > articles").first.css("title").first.text
    assert_equal "http://example.com/image/1" , xml.css("root > articles").first.css("link").first["href"]
    assert_equal "image"                      , xml.css("root > articles").first.css("link").first["rel"]
    assert_equal "application/json"           , xml.css("root > articles").first.css("link").last["type"]
  end

end
