# encoding: utf-8
Gem::Specification.new do |s|
  s.name             = 'rails_locale_detection'
  s.version          = File.read('VERSION').strip
  s.authors          = ['Mateo Murphy']
  s.email            = ['mateo.murphy@gmail.com']
  s.description      = 'Sets the current locale of a request using a combination of params, cookies, and http headers'
  s.summary          = 'Locale setting for rails project'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.homepage         = 'http://github.com/mateomurphy/rails_locale_detection'
  s.license          = 'MIT'

  s.files            = `git ls-files -z`.split("\0")
  s.require_paths    = ['lib']


  rails_version      = ['>= 3.2', '< 5']
  rspec_version      = '~> 3'

  s.add_runtime_dependency 'activesupport', *rails_version
  s.add_runtime_dependency 'http_accept_language', '>= 0'

  s.add_development_dependency 'appraisal', '~> 1'
  s.add_development_dependency 'bundler', '~> 1'
  s.add_development_dependency 'i18n', '>= 0'
  s.add_development_dependency 'pry-rails', '>= 0'
  s.add_development_dependency 'rake', '>= 0'
  s.add_development_dependency 'rails', *rails_version
  s.add_development_dependency 'rspec', *rspec_version
  s.add_development_dependency 'rspec-rails', *rspec_version
end
