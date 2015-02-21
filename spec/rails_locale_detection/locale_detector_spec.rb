require 'spec_helper'

describe RailsLocaleDetection::LocaleDetector do
  let(:request) { MockRequest.new }
  let(:controller) { MockController.new(request) }
  subject(:locale_detector) { RailsLocaleDetection::LocaleDetector.new(controller) }

  describe '#available_locales' do
    context "shadows I18n.available_locales" do
      it { expect(locale_detector.available_locales).to eq([:en, :fr]) }
    end
  end

  describe '#default_locale' do
    context "shadows I18n.default locale"  do
      it { expect(locale_detector.default_locale).to eq(:en) }
    end
  end

  describe '#current_locale' do
    context "shadows I18n.locale"  do
      before do
        controller.params[:locale] = 'fr'
        locale_detector.set_locale
      end
      it { expect(controller.current_locale).to eq(:fr) }
    end
  end

  describe '#validate_locale' do
    context "returns the passed locale if it's valid" do
      it { expect(locale_detector.validate_locale(:en)).to eq(:en) }
    end

    context "returns nil if the passed locale isn't valid" do
      it { expect(locale_detector.validate_locale(:es)).to be_nil }
    end

    context "returns nil if nil is passed" do
      it { expect(locale_detector.validate_locale(nil)).to be_nil }
    end
  end

  describe '#locale_from_param' do
    context "returns en if the param set was valid" do
      before { controller.params[:locale] = 'en' }
      it { expect(locale_detector.locale_from_param).to eq(:en) }
    end

    context "returns nil if the param set was not" do
      before { controller.params[:locale] = 'es' }
      it { expect(locale_detector.locale_from_param).to be_nil }
    end

    context "returns nil if not locale was set" do
      it { expect(locale_detector.locale_from_param).to be_nil }
    end
  end

  describe '#locale_from_cookie' do
    context "returns en if the param set was valid" do
      before { controller.request.cookie_jar[:locale] = 'en' }
      it { expect(locale_detector.locale_from_cookie).to eq(:en) }
    end

    context "returns nil if the param set was not" do
      before { controller.request.cookie_jar[:locale] = 'es' }
      it { expect(locale_detector.locale_from_cookie).to be_nil }
    end

    context "returns nil if not locale was set" do
      it { expect(locale_detector.locale_from_cookie).to be_nil }
    end
  end

  describe '#locale_from_request' do
    context "returns en if the param set was valid" do
      before { request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6' }
      it { expect(locale_detector.locale_from_request).to eq(:en) }
    end

    context "returns nil if the param set was not" do
      before { request.env['HTTP_ACCEPT_LANGUAGE'] = 'es' }
      it { expect(locale_detector.locale_from_request).to be_nil }
    end

    context "returns nil if not locale was set" do
      it { expect(locale_detector.locale_from_request).to be_nil }
    end
  end

  describe '#locale_from_user' do
    context "returns the locale of the user if it's valid" do
      before { controller.user = MockUser.new(:en) }
      it { expect(locale_detector.locale_from_user).to eq(:en) }
    end

    context "returns nil if the locale of the use isn't valid" do
      before { controller.user = MockUser.new(:es) }
      it { expect(locale_detector.locale_from_user).to be_nil }
    end
  end

  describe '#locale_from' do
    before :each do
      controller.params[:locale] = 'en'
      controller.request.cookie_jar[:locale] = 'fr'
    end

    context "returns the locale set in the param" do
      it { expect(locale_detector.locale_from(:param)).to eq(:en) }
    end

    context "return the locale set in the cookie" do
      it { expect(locale_detector.locale_from(:cookie)).to eq(:fr) }
    end
  end

  describe '#detect_locale' do
    context "with default detection order" do
      before :each do
        RailsLocaleDetection.detection_order = [:user, :param, :cookie, :request]
      end

      context "returns default if nothing is set" do
        it { expect(locale_detector.detect_locale).to eq(:en) }
      end

      context "returns en if the params is set to en" do
        before { controller.params[:locale] = "en" }
        it { expect(locale_detector.detect_locale).to eq(:en) }
      end

      context "returns fr if the cookie is set to fr" do
        before { controller.request.cookie_jar[:locale] = "fr" }
        it { expect(locale_detector.detect_locale).to eq(:fr) }
      end

      context "returns en if the request is set to en" do
        before { request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6' }
        it { expect(locale_detector.detect_locale).to eq(:en) }
      end

      context "return fr if the user locale was set to fr" do
        before { controller.user = MockUser.new(:en) }
        it { expect(locale_detector.detect_locale).to eq(:en) }
      end
    end

    context "with a custom detection order" do
      before :each do
        RailsLocaleDetection.detection_order = [:user, :param, :request]
      end

      context "returns return default if nothing is set" do
        it { expect(locale_detector.detect_locale).to eq(:en) }
      end

      context "returns en if the params is set to en" do
        before { controller.params[:locale] = "en" }
        it { expect(locale_detector.detect_locale).to eq(:en) }
      end

      context "skips cookie" do
        before { controller.request.cookie_jar[:locale] = "fr" }
        it { expect(locale_detector.detect_locale).to eq(:en) }
      end

      context "returns en if the request is set to en" do
        before { request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6' }
        it { expect(locale_detector.detect_locale).to eq(:en) }
      end
    end
  end

  describe '#set_default_url_option_for_request?' do
    context 'with a locale param' do
      before :each do
        controller.params[:locale] = "fr"
      end

      context 'return true when set_default_url_option is true' do
        before { RailsLocaleDetection.set_default_url_option = true }
        it { expect(locale_detector).to be_set_default_url_option_for_request }
      end

      context 'return false when set_default_url_option is fale' do
        before { RailsLocaleDetection.set_default_url_option = false }
        it { expect(locale_detector).not_to be_set_default_url_option_for_request }
      end

      context 'return false when set_default_url_option is :never' do
        before { RailsLocaleDetection.set_default_url_option = :never }
        it { expect(locale_detector).not_to be_set_default_url_option_for_request }
      end

      context 'return true when set_default_url_option is :always' do
        before { RailsLocaleDetection.set_default_url_option = :always }
        it { expect(locale_detector).to be_set_default_url_option_for_request }
      end

      context 'return true when set_default_url_option is :explicitly' do
        before { RailsLocaleDetection.set_default_url_option = :explicitly }
        it { expect(locale_detector).to be_set_default_url_option_for_request }
      end
    end

    context 'without a locale param' do
      before :each do
        controller.params[:locale] = nil
      end

      context 'return true when set_default_url_option is true' do
        before { RailsLocaleDetection.set_default_url_option = true }
        it { expect(locale_detector).to be_set_default_url_option_for_request }
      end

      context 'return false when set_default_url_option is false' do
        before { RailsLocaleDetection.set_default_url_option = false }
        it { expect(locale_detector).to_not be_set_default_url_option_for_request }
      end

      context 'return false when set_default_url_option is :never' do
        before { RailsLocaleDetection.set_default_url_option = :never }
        it { expect(locale_detector).to_not be_set_default_url_option_for_request }
      end

      context 'return true when set_default_url_option is :always' do
        before { RailsLocaleDetection.set_default_url_option = :always }
        it { expect(locale_detector).to be_set_default_url_option_for_request }
      end

      context 'return false when set_default_url_option is :explicitly' do
        before { RailsLocaleDetection.set_default_url_option = :explicitly }
        it { expect(locale_detector).to_not be_set_default_url_option_for_request }
      end
    end
  end

  describe '#set_locale' do
    context "with set default_url_option :always" do
      before :each do
        RailsLocaleDetection.set_default_url_option = :always
        controller.params[:locale] = "fr"
        locale_detector.set_locale
      end

      context "sets the current locale to the locale param" do
        it { expect(I18n.locale).to eq(:fr) }
      end

      context "sets the language" do
        it { expect(controller.request.cookie_jar[:locale]).to eq(:fr) }
      end

      context "sets the default_url_options" do
        it { expect(controller.default_url_options[:locale].to_s).to eq('fr') }
      end
    end

    context "with set default_url_option :never" do
      before :each do
        RailsLocaleDetection.set_default_url_option = :never
        controller.default_url_options = {}
        controller.params[:locale] = "fr"
        locale_detector.set_locale
      end

      context "sets the current locale to the locale param" do
        it { expect(I18n.locale).to eq(:fr) }
      end

      context "sets the cookier locale" do
        it { expect(controller.request.cookie_jar[:locale]).to eq(:fr) }
      end

      context "doesn't set the default_url_options" do
        it { expect(controller.default_url_options[:locale]).to be_nil }
      end
    end

    context "with set default_url_option :explicit and no locale param" do
      before :each do
        RailsLocaleDetection.set_default_url_option = :explicitly
        controller.default_url_options = {}
        controller.params[:locale] = nil
        locale_detector.set_locale
      end

      context "sets the current locale to the default param" do
        it { expect(I18n.locale).to eq(:en) }
      end

      context "sets the cookie locale" do
        it { expect(controller.request.cookie_jar[:locale]).to eq(:en) }
      end

      context "doesn't set the default_url_options" do
        it { expect(controller.default_url_options[:locale]).to be_nil }
      end
    end

    context "with set default_url_option :explicit and a locale param" do
      before :each do
        RailsLocaleDetection.set_default_url_option = :explicitly
        controller.default_url_options = {}
        controller.params[:locale] = :fr
        locale_detector.set_locale
      end

      context "sets the current locale to the default param" do
        it { expect(I18n.locale).to eq(:fr) }
      end

      context "sets the cookie locale" do
        it { expect(controller.request.cookie_jar[:locale]).to eq(:fr) }
      end

      context "doesn't set the default_url_options" do
        it { expect(controller.default_url_options[:locale]).to eq(:fr) }
      end
    end
  end
end
