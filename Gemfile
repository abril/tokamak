source :rubygems

# Main dependencies
gem "json_pure", :require => "json/pure"
gem "nokogiri"

# Other dependencies
group :development, :test do
  gem "ruby-debug"  , :platforms => [:mri_18]
  gem "ruby-debug19", :platforms => [:mri_19]

  gem "methodize"  
  gem "rack"       , "~>1.1"
  gem "rack-test"  , :require => "rack/test"
  gem "rack-conneg", :require => "rack/conneg"
  gem "tilt"       , "~>1.2"
  gem "sinatra"    , "~>1.1"
  gem "rails"      , "2.3.8"
end
