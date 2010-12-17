$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"
# require other dependencies here...

# Gem requirements
# Your can require or autoload gem files here, see examples below
# require "gem_name/file"
# module GemName
  # autoload :AClass      , "migrator/a_class"
  # autoload :AnotherClass, "migrator/another_class"
# end

module Tokamak
  autoload :Recipes, "tokamak/recipes"
end

