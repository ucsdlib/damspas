require 'spec_helper'

describe MadsNamesController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	#MadsNameCollection.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = MadsName.create(name: " Name Test ", externalAuthority:  "http://lccn.loc.gov/n90694888")
	    end
	    it "should be successful" do 
	      get :view, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:mads_name]
          @newobj.name.should == @obj.name
          @newobj.externalAuthority.should == @obj.externalAuthority
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:mads_name].should be_kind_of MadsName
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = MadsName.create(name: "Name", externalAuthority: "http://lccn.loc.gov/n90694888")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:mads_name]
          @newobj.name.should == @obj.name
          @newobj.externalAuthority.should == @obj.externalAuthority
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :mads_name => {name: ["Test Name"] , externalAuthority:  "http://lccn.loc.gov/n90694888"}
        }.to change { MadsName.count }.by(1)
	      response.should redirect_to assigns[:mads_name]
	      assigns[:mads_name].should be_kind_of MadsName
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = MadsName.create(name: "Original Name", externalAuthority: "http://lccn.loc.gov/n90694888")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :mads_name => {name: ["Updated Name"], externalAuthority:  ["http://lccn.loc.gov/n90694888"]}
	      response.should redirect_to assigns[:mads_name]
          @newobj = assigns[:mads_name]
	      @newobj.name.should == ["Updated Name"]
	      flash[:notice].should == "Successfully updated name"
	    end
    end
  end
end

