require 'spec_helper'

class AccessorTest
  include RailsLocaleDetection::LocaleAccessors
end

describe RailsLocaleDetection::LocaleAccessors do
  subject(:object) { AccessorTest.new }
  
  describe '#alternate_locales' do
    context "return available locales but current" do
      before { object.current_locale = :en }
      it { expect(object.alternate_locales).to eq([:fr]) }
    end
  end

  describe '#available_locales' do
    context "shadows I18n.available_locales" do
      it { expect(object.available_locales).to eq([:en, :fr]) }
    end
  end

  describe '#default_locale' do
    context "shadows I18n.default locale"  do
      it { expect(object.default_locale).to eq(:en) }
    end
  end
end
