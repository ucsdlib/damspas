require 'spec_helper'

RSpec.describe Aeon::QueuesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Aeon::Queue. As you add validations to Aeon::Queue, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Aeon::QueuesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      queue = Aeon::Queue.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
    end
  end

end
