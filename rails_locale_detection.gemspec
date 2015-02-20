# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'rails_locale_detection'
  s.version = File.read('VERSION')

  s.authors = ['Mateo Murphy']
  s.date = '2013-02-23'
  s.description = 'Sets the current locale of a request using a combination of params, cookies, and http headers'
  s.email = 'mateo.murphy@gmail.com'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.files = [
    '.document',
    '.rspec',
    'Gemfile',
    'LICENSE.txt',
    'README.md',
    'Rakefile',
    'lib/rails/locale_detection.rb',
    'lib/rails_locale_detection.rb',
    'rails_locale_detection.gemspec',
    'spec/rails_locale_detection_spec.rb',
    'spec/spec_helper.rb',
    'spec/support/mock.rb'
  ]
  s.homepage = 'http://github.com/mateomurphy/rails_locale_detection'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.25'
  s.summary = 'locale setting for rails project'

  rails_version = '< 5', '>= 3.2.12'
  s.add_runtime_dependency 'activesupport', *rails_version
  s.add_runtime_dependency 'http_accept_language', '>= 0'

  s.add_development_dependency 'i18n', '>= 0'
  s.add_development_dependency 'timecop', '>= 0'
  s.add_development_dependency 'actionpack', *rails_version
  s.add_development_dependency 'rspec', '~> 2.12'
  s.add_development_dependency 'bundler', '~> 1'
  s.add_development_dependency 'rake', '>= 0'
  s.add_development_dependency 'pry', '>= 0'
end

