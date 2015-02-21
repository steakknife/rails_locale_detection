require 'spec_helper'

describe CallbackTestsController, :type => :controller do
  it 'automatically include callback' do
    expect(subject.class.ancestors).to include(RailsLocaleDetection::ControllerMethods)
  end
  
  describe 'detect user locale' do
    before { get :show }
    it { expect(response.body).to eq('fr') }
  end
end
