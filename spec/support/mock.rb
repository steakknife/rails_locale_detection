class MockRequest
  include HttpAcceptLanguage
  
  attr_accessor :env

  def env
    @env ||= {}
  end

  def accept_language
    env['HTTP_ACCEPT_LANGUAGE'] || ''
  end
  
  def preferred_language_from(*opts)
    HttpAcceptLanguage::Parser.new(accept_language).preferred_language_from(*opts)
  end
end

class MockController
  include Rails::LocaleDetection
  
  attr_accessor :request, :params, :cookies, :default_url_options, :user
  
  def initialize(request)
    @request = request
    @cookies = ActionDispatch::Cookies::CookieJar.new(nil)
    @default_url_options = @params = {}
  end
  
  def user_locale
    return user.locale if user
  end
end

class MockUser
  attr_accessor :locale
  
  def initialize(locale)
    @locale = locale
  end
end
