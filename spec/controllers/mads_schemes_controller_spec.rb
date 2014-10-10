require 'spec_helper'

describe MadsSchemesController do
  describe "A logged-in user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
    	#DamsVocabularyEntry.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = MadsScheme.create( code: "test", name: "Test Scheme" )
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	    end
	  end
  end
end

