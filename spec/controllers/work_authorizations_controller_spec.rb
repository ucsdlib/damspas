require 'spec_helper'

RSpec.describe WorkAuthorizationsController, type: :controller do

  describe "GET #index" do
    sign_in_anonymous '132.239.0.3'
    it "doesn't throw an error" do
      get :index
      expect(response).to have_http_status(:success).or have_http_status(302)
    end
  end
end
