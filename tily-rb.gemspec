require './lib/tily/version'

Gem::Specification.new do |s|
  s.name = 'tily.rb'
  s.version = Tily::VERSION
  s.author = 'Peng Sun'
  s.email = 'voidmain1313113@gmail.com'

  s.description = 'A simple map tile generator that divides huge images into classifed levels, with small tile images.'
  s.summary = 'A simple map tile generator that divides huge images into classifed levels, with small tile images.'
  s.homepage = 'https://github.com/void-main/tily.rb'
  s.license = 'Apache v2 License'

  s.platform = Gem::Platform::RUBY
  s.require_paths = %w[lib]
  s.files = `git ls-files`.split("\n")
  s.test_files = Dir['spec/**/*.rb']

  s.add_dependency('rmagick', '>= 2.13.2')

  s.add_development_dependency 'rake',    '~> 0.9.0'
  s.add_development_dependency 'rspec',   '~> 2.6.0'

  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.rdoc_options = ['--line-numbers', '--inline-source', '--title', 'tily.rb', '--main', 'README.md']
end