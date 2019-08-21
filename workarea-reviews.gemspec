$:.push File.expand_path('../lib', __FILE__)

require 'workarea/reviews/version'

Gem::Specification.new do |s|
  s.name        = 'workarea-reviews'
  s.version     = Workarea::Reviews::VERSION
  s.authors     = ['Ben Crouse']
  s.email       = ['bcrouse@workarea.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-reviews'
  s.summary     = 'Reviews plugin for the Workarea ecommerce platform'
  s.description = 'Plugin for product reviews on the Workarea ecommerce platform'

  s.files = `git ls-files`.split("\n")

  s.license = 'Business Software License'

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'workarea', '~> 3.x', '>= 3.5.x'
  s.add_dependency 'recaptcha', '~> 4.3.1'
end
