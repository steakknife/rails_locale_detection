class MockRequest
  include HttpAcceptLanguage

  attr_writer :cookies, :cookie_jar, :env

  def cookie_jar
    @cookie_jar ||= ActionDispatch::Cookies::CookieJar.build(self)
  end

  def cookies
    @cookies ||= {}
  end

  def env
    @env ||= {}
  end

  def http_accept_language
    env['HTTP_ACCEPT_LANGUAGE'] || ''
  end

  def preferred_language_from(opts)
    p = HttpAcceptLanguage::Parser.new(http_accept_language)
    p.preferred_language_from(opts)
  end
  
  def host
    'localhost'
  end
    
  def ssl?
    false
  end
end

class MockUser
  attr_accessor :locale

  def initialize(locale)
    @locale = locale
  end
end

class MockController
  attr_accessor :request, :params, :default_url_options, :user

  def initialize(request)
    @request = request
  end

  def default_url_options
    @default_url_options ||= {}
  end

  def params
    @params ||= {}
  end

  def user_locale
    return user.locale if user
  end

  class << self
    attr_reader :before_filters
  end

  def self.before_filter(*args)
    @before_filters ||= []
    @before_filters << args
  end

  def self.append_before_filter(*args)
    @before_filters ||= []
    @before_filters << args
  end

  include RailsLocaleDetection::ControllerMethods
end
