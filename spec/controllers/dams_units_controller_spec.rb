require 'spec_helper'

describe DamsUnitsController do

  describe "GET 'view'" do
    before do
      sign_in User.create!
    end

    DamsUnit.create pid: "bb48484848", name: "Research Data Curation Program", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://rci.ucsd.edu/", code: "rci"

    it "returns http success" do
      get 'show', :id => 'rci'
      response.should be_success
    end
  end

end
