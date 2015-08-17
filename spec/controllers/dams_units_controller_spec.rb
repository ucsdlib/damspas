require 'spec_helper'

describe DamsUnitsController do

  describe "GET 'view'" do
    before do
      sign_in User.create! ({:provider => 'developer'})
      @unit = DamsUnit.create pid: "un48484848", name: "Research Data Curation Program", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://rci.ucsd.edu/", code: "unrdcp", group: "dams-rci"
    end
    after do
      @unit.delete
    end

    it "returns http success" do
      get 'show', :id => 'unrdcp'
      expect(response.status).to eq(200)
    end
  end

end
