require 'action_view'
require 'abstract_controller'
require 'action_controller'
require 'active_support'

require 'rspec/rails'

require 'rails_locale_detection'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

I18n.default_locale = :en
I18n.available_locales = [:en, :fr]
