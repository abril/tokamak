# Tokamak

Is a template engine for hypermedia resources that provides a single DSL to generate several media types representations.

This version supports json and xml generation (you can add other media types
easily)

The lib provide hooks for:

* Rails
* Sinatra
* Tilt ([https://github.com/rtomayko/tilt](https://github.com/rtomayko/tilt))

Just put `require "tokamak/hook/[sinatra|rails|tilt]"` on your app. See unit
tests for hook samples.

You are also able to implement hooks for other frameworks.

## Sample

### Tokamak code

    collection(@some_articles) do |collection|
        collection.values do |values|
            values.id      "http://example.com/json"
            values.title   "Feed"
            values.updated Time.now

            values.author {
                values.name  "John Doe"
                values.email "joedoe@example.com"
            }

            values.author {
                values.name  "Foo Bar"
                values.email "foobar@example.com"
            }
        end

        collection.link("next"    , "http://a.link.com/next")
        collection.link("previous", "http://a.link.com/previous")

        collection.members(:root => "articles") do |member, article|
            member.values do |values|
                values.id      "uri:#{article[:id]}"
                values.title   article[:title]
                values.updated article[:updated]
            end

            member.link("image", "http://example.com/image/1")
            member.link("image", "http://example.com/image/2", :type => "application/json")
        end
    end

Generates the following representations:

### JSON

    {
        "author": [{
            "name": "John Doe",
            "email": "joedoe@example.com"
        },
        {
            "name": "Foo Bar",
            "email": "foobar@example.com"
        }],
        "title": "Feed",
        "id": "http://example.com/json",
        "link": [{
            "href": "http://a.link.com/next",
            "rel": "next",
            "type": "application/json"
        },
        {
            "href": "http://a.link.com/previous",
            "rel": "previous",
            "type": "application/json"
        }],
        "articles": [{
            "title": "a great article",
            "id": "uri:1",
            "link": [{
                "href": "http://example.com/image/1",
                "rel": "image",
                "type": "application/json"
            },
            {
                "type": "application/json",
                "href": "http://example.com/image/2",
                "rel": "image",
                "type": "application/json"
            }],
            "updated": "2011-01-05T10:40:58-02:00"
        },
        {
            "title": "another great article",
            "id": "uri:2",
            "link": [{
                "href": "http://example.com/image/1",
                "rel": "image",
                "type": "application/json"
            },
            {
                "type": "application/json",
                "href": "http://example.com/image/2",
                "rel": "image",
                "type": "application/json"
            }],
            "updated": "2011-01-05T10:40:58-02:00"
        }],
        "updated": "2011-01-05T10:40:58-02:00"
    }

### XML

    <?xml version="1.0"?>
    <root>
      <id>http://example.com/json</id>
      <title>Feed</title>
      <updated>2011-01-05T10:40:58-02:00</updated>
      <author>
        <name>John Doe</name>
        <email>joedoe@example.com</email>
      </author>
      <author>
        <name>Foo Bar</name>
        <email>foobar@example.com</email>
      </author>
      <link href="http://a.link.com/next" rel="next" type="application/xml"/>
      <link href="http://a.link.com/previous" rel="previous" type="application/xml"/>
      <articles>
        <id>uri:1</id>
        <title>a great article</title>
        <updated>2011-01-05T10:40:58-02:00</updated>
        <link href="http://example.com/image/1" rel="image" type="application/xml"/>
        <link href="http://example.com/image/2" type="application/json" rel="image"/>
      </articles>
      <articles>
        <id>uri:2</id>
        <title>another great article</title>
        <updated>2011-01-05T10:40:58-02:00</updated>
        <link href="http://example.com/image/1" rel="image" type="application/xml"/>
        <link href="http://example.com/image/2" type="application/json" rel="image"/>
      </articles>
    </root>

## Other features

* You can declare recipes once and reuse it later (see `Tokamak::Recipes`)
* You can extend `Tokamak::Builder::Base` to support a custom media type.
* You can customize the DSL entrypoint helpers, used by the hooks (see `Tokamak::Builder::HelperTest`)

## Want to know more?

Please check the unit tests, you can see a lot of richer samples, including tests for the hooks.

*This library was extracted from [Restfulie](https://github.com/caelum/restfulie) and then heavy refactored. The same terms apply, see LICENSE.txt*

