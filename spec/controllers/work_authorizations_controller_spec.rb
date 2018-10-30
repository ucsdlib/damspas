require 'spec_helper'

RSpec.describe WorkAuthorizationsController, type: :controller do

  describe "GET #index" do
    sign_in_anonymous '132.239.0.3'
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
