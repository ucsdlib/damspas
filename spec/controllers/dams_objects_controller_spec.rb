require 'spec_helper'

describe DamsObjectsController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
	  end
	  describe "View" do
	    before do
	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :view, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_object].should == @obj
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_object].should be_kind_of DamsObject
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013")
	    end
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_object].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :dams_object => {titleValue: ["Test Title"], beginDate: ["2013"]}
        }.to change { DamsObject.count }.by(1)
	      response.should redirect_to assigns[:dams_object]
	      assigns[:dams_object].should be_kind_of DamsObject
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :dams_object => {titleValue: ["Test Title2"], beginDate: ["2013"]}
	      response.should redirect_to assigns[:dams_object]
	      @obj.reload.titleValue.should == ["Test Title2"]
	      flash[:notice].should == "Successfully updated object"
	    end
    end
  end
end
