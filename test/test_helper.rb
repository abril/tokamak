require 'test/unit'
require 'rubygems'
require "methodize"

begin
  require 'ruby-debug'
rescue Exception => e; end

require File.expand_path(File.dirname(__FILE__) + '/../lib/tokamak.rb')

