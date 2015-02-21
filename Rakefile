require 'appraisal'

require 'bundler/gem_tasks'

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.read('VERSION').strip

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rails_locale_detection #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:rcov) do |rcov|
  rcov.pattern = 'spec/**/*_spec.rb'
  rcov.rcov = true
end
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
