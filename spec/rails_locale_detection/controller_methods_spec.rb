require 'spec_helper'

describe RailsLocaleDetection::ControllerMethods do
  let(:request) { MockRequest.new }
  subject(:controller) { MockController.new(request) }

  context 'provides a blank user locale method' do
    it { expect(controller.user_locale).to be_nil }
  end
  
  context 'should provide a detect locale method' do
    it { expect(controller.class).to respond_to(:detect_locale) }
  end 
  
  context 'should add a before filter' do
    it { expect(controller.class.before_filters).to eq([[RailsLocaleDetection::LocaleDetector]]) }
  end
end
