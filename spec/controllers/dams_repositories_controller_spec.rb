require 'spec_helper'

describe DamsRepositoriesController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    before do
      sign_in User.create!
    end

    DamsRepository.create pid: "bb45454545", name: "RCI", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://library.ucsd.edu/repo/rci/"

    it "returns http success" do
      get 'show', :id => 'bb45454545'
      response.should be_success
    end
  end

end
