Gem::Specification.new do |s|
  s.name          = "Tokamak"
  s.version       = "0.0.1"
  s.platform      = Gem::Platform::RUBY
  s.summary       = "A template handler that generates several media types representations, from a simple DSL"

  s.require_paths = ['lib']
  s.files         = Dir["{lib/**/*.rb,README.md,test/**/*.rb,Rakefile,*.gemspec,script/*}"]

  s.author        = "Luis Cipriani"
  s.email         = "lfcipriani@gmail.com"
  s.homepage      = "http://www.abril.com.br"

  # s.add_dependency('dependency', '>= 1.0.0')

  # s.add_development_dependency('cover_me')
  # s.add_development_dependency('ruby-debug19')
end
