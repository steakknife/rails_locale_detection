class MockApplication
  def self.env_config
    {}
  end
  
  def self.routes
    @routes ||= ActionDispatch::Routing::RouteSet.new
  end

  (Rails.application = self).routes.draw do
    resource :callback_tests
  end
end

class CallbackTestsController < ActionController::Base
  include RailsLocaleDetection::ControllerMethods
  include Rails.application.routes.url_helpers  

  def user_locale
    :fr
  end
  
  def show
    render :text => current_locale
  end
end
