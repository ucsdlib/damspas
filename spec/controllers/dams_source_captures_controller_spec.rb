require 'spec_helper'

describe DamsSourceCapturesController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	DamsSourceCapture.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsSourceCapture.create(scannerManufacturer: "transmission scanner")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_source_capture].should == @obj
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_source_capture].should be_kind_of DamsSourceCapture
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = DamsSourceCapture.create(scannerManufacturer: "transmission scanner")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_source_capture].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :dams_source_capture => {scannerManufacturer: ["transmission scanner"]}
        }.to change { DamsSourceCapture.count }.by(1)
	      response.should redirect_to assigns[:dams_source_capture]
	      assigns[:dams_source_capture].should be_kind_of DamsSourceCapture
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = DamsSourceCapture.create(scannerManufacturer: "transmission scanner")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :dams_source_capture => {scannerManufacturer: ["transmission scanner"]}
	      response.should redirect_to assigns[:dams_source_capture]
	      flash[:notice].should == "Successfully updated source capture"
	    end
    end
  end
end

