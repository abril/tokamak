$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"

# Lib
module Tokamak
  def self.builder_lookup(media_type)
    builder = Tokamak::Builder::Base.global_media_types[media_type[/^([^\s\;]+)/, 1]]
    builder.nil? ?
      (raise Tokamak::BuilderError.new("Could not find a builder for the media type: #{media_type}")) : 
      builder
  end
end

require "tokamak/errors"
require "tokamak/recipes"
require "tokamak/builder"
require "tokamak/hook"
