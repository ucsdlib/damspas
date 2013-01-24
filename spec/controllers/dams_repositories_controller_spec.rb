require 'spec_helper'

describe DamsRepositoriesController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => '123'
      response.should be_success
    end
  end

end
