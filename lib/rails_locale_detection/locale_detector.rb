module RailsLocaleDetection
  class LocaleDetector
    include DetectionMethods
    include LocaleAccessors
    
    attr_reader :controller
    
    delegate :params, :request, :default_url_options, :user_locale, :to => :controller
    
    def initialize(controller = nil)
      @controller = controller
    end
    
    def cookies
      request.cookie_jar
    end
    
    def locale_key
      RailsLocaleDetection.locale_key
    end
    
    def self.before(controller)
      new(controller).set_locale
    end
  end
end