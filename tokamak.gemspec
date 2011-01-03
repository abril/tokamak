Gem::Specification.new do |s|
  s.name          = "Tokamak"
  s.version       = "1.0.0"
  s.platform      = Gem::Platform::RUBY
  s.summary       = "A template handler that generates several media types representations, from a simple DSL"

  s.require_paths = ['lib']
  s.files         = Dir["{lib/**/*.rb,README.md,LICENSE,test/**/*,script/*}"]

  s.author        = "Luis Cipriani"
  s.email         = "luis.cipriani@abril.com.br"
  s.homepage      = "http://github.com/abril/tokamak"

  s.add_dependency('json_pure')
  s.add_dependency('nokogiri')

  s.add_development_dependency('ruby-debug')
  s.add_development_dependency('methodize')
  s.add_development_dependency('rails',"~>2.3")
  s.add_development_dependency('rack-conneg')
end
