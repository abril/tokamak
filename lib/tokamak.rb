$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"
require "json/pure"
require "nokogiri"

# Lib
module Tokamak
  def self.builder_lookup(media_type)
    Tokamak::Builder::Base.global_media_types[media_type]
  end
end

require "tokamak/errors"
require "tokamak/recipes"
require "tokamak/builder"
