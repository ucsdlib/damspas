require 'spec_helper'

describe DamsLanguagesController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	#DamsLanguage.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsLanguage.create(value: "Vocab Entry value", vocabulary: "http://library.ucsd.edu/ark:/20775/bb43434343")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_language].should == @obj
	    end
	  end	 
  end
end

