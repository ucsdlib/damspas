require 'spec_helper'

describe MadsSchemesController do
  describe "A logged-in user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
        @obj = MadsScheme.create( code: "test", name: "Test Scheme" )
	  end
	  after do
        @obj.delete
	  end
	  describe "Show" do
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	    end
	  end
  end
end

