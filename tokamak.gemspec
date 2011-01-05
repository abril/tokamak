Gem::Specification.new do |s|
  s.name          = "Tokamak"
  s.version       = "2.3.2"
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
  s.add_development_dependency('rack',"~>1.2")
  s.add_development_dependency('rack-test')
  s.add_development_dependency('rack-conneg')
  s.add_development_dependency('tilt',"~>1.2")
  s.add_development_dependency('sinatra',"~>1.1")
  s.add_development_dependency('rails',"~>3.0")
end
