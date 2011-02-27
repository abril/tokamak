$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"

module Tokamak
end

require "tokamak/errors"
require "tokamak/recipes"
require "tokamak/builder"
require "tokamak/registry"
require "tokamak/hook"
