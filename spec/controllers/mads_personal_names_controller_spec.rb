require 'spec_helper'

describe MadsPersonalNamesController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	#MadsPersonalNameCollection.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = MadsPersonalName.create(name: "Personal Name Test ", externalAuthority: "http://lccn.loc.gov/n90694888")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :view, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:mads_personal_name]
          @newobj.name.should == @obj.name
          @newobj.externalAuthority.should == @obj.externalAuthority
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:mads_personal_name].should be_kind_of MadsPersonalName
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = MadsPersonalName.create(name: "Personal Name", externalAuthority:  "http://lccn.loc.gov/n90694888")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:mads_personal_name]
          @newobj.name.should == @obj.name
          @newobj.externalAuthority.should == @obj.externalAuthority
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :mads_personal_name => {name: ["Test Name"] , externalAuthority:  "http://lccn.loc.gov/n90694888"}
        }.to change { MadsPersonalName.count }.by(1)
	      response.should redirect_to assigns[:mads_personal_name]
	      assigns[:mads_personal_name].should be_kind_of MadsPersonalName
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = MadsPersonalName.create(name: "Personal Name", externalAuthority:  "http://lccn.loc.gov/n90694888")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :mads_personal_name => {name: ["Test Title2"], externalAuthority:  ["http://lccn.loc.gov/n90694888"]}
	      response.should redirect_to assigns[:mads_personal_name]
	      @obj.reload.name.should == ["Test Title2"]
	      flash[:notice].should == "Successfully updated personal_name"
	    end
    end
  end
end

