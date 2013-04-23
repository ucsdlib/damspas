require 'spec_helper'

describe DamsUnitsController do

  describe "GET 'view'" do
    before do
      sign_in User.create!
    end

    DamsUnit.create pid: "bb45454545", name: "RCI", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://rci.ucsd.edu/"

    it "returns http success" do
      get 'view', :id => 'bb45454545'
      response.should be_success
    end
  end

end
