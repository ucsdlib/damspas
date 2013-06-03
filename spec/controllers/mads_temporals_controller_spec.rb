require 'spec_helper'

describe MadsTemporalsController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = MadsTemporal.create(name: "Test Title", elementListValue: "2013")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :mads_temporal => {name: ["Test Title2"], elementListValue: ["2014"]}
	      #response.should redirect_to assigns[:dams_object]
	      response.should redirect_to edit_mads_temporal_path(@obj)
	      @obj.reload.name.should == ["Test Title2"]
	      flash[:notice].should == "Successfully updated Temporal"
	    end
    end
  end
end
