require 'spec_helper'

describe DamsPersonalNamesController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	#DamsPersonalNameCollection.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsPersonalName.create(name: "Personal Name Test ")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_personal_name].should == @obj
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_personal_name].should be_kind_of DamsPersonalName
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = DamsPersonalName.create(name: "Personal Name")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_personal_name].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :dams_personal_name => {name: ["Test Name"]}
        }.to change { DamsPersonalName.count }.by(1)
	      response.should redirect_to assigns[:dams_personal_name]
	      assigns[:dams_personal_name].should be_kind_of DamsPersonalName
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = DamsPersonalName.create(name: "Personal Name")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :dams_personal_name => {name: ["Test Title2"]}
	      response.should redirect_to assigns[:dams_personal_name]
	      #@obj.reload.title.should == ["Test Title2"]
          pending "check title after reload #{__FILE__}"
	      flash[:notice].should == "Successfully updated personal name"
	    end
    end
  end
end

