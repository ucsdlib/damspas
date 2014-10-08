require 'spec_helper'

describe DamsSourceCapturesController do
  describe "A login user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
    	#DamsSourceCapture.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsSourceCapture.create(scannerManufacturer: "transmission scanner")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:dams_source_capture]
          @newobj.scannerManufacturer.should == @obj.scannerManufacturer
	    end
	  end
  end
end

