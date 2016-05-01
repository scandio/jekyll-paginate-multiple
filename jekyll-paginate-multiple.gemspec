lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-paginate-multiple/version'


Gem::Specification.new do |s|
  s.name        = "jekyll-paginate-multiple"
  s.summary     = "Jekyll pagination generator for multiple paths"
  s.description = "Jekyll pagination generator for multiple paths"
  s.version     = Jekyll::Paginate::Multiple::VERSION
  s.authors     = ["Georg Schmidl"]
  s.email       = ["georg.schmidl@scandio.de"]

  s.homepage    = "https://github.com/scandio/jekyll-paginate-multiple"
  s.licenses    = ["MIT"]
  s.files       = ["lib/jekyll-paginate-multiple.rb"]

  s.add_dependency "jekyll", '>= 2.5'
  s.add_dependency "jekyll-paginate", "~> 1.1"

  s.add_development_dependency  'rake', '~> 0'
end
