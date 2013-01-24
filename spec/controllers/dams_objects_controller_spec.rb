require 'spec_helper'

describe DamsObjectsController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
	  end
	  describe "Show" do
	    before do
	      @obj = DamsObject.create(title: "Test Title", date: "2013")
	      puts @obj.id
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
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
	      @obj = DamsObject.create(title: "Test Title", date: "2013")
	    end
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_object].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      before = DamsObject.count 
	      post :create, :dams_object => {title: ["Test Title"], date: ["2013"], subject: ["Test subject"]}
	      response.should redirect_to catalog_index_path
	      assigns[:dams_object].should be_kind_of DamsObject
	      DamsObject.count.should == before + 1
	    end
	  end
  end
end
