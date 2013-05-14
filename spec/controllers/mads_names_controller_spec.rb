require 'spec_helper'

describe MadsNamesController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	#MadsNameCollection.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = MadsName.create(name: " Name Test ", sameAs:  "http://lccn.loc.gov/n90694888", valueURI: "http://id.loc.gov/n9999999991")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :view, id: @obj.id
	      response.should be_successful 
	      assigns[:mads_name].should == @obj
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
	      @obj = MadsName.create(name: "Name", sameAs:  "http://lccn.loc.gov/n90694888", valueURI: "http://id.loc.gov/n9999999992")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:mads_name].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :mads_name => {name: ["Test Name"] , sameAs:  "http://lccn.loc.gov/n90694888", valueURI: "http://id.loc.gov/n9999999993"}
        }.to change { MadsName.count }.by(1)
	      response.should redirect_to assigns[:mads_name]
	      assigns[:mads_name].should be_kind_of MadsName
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = MadsName.create(name: "Original Name", sameAs:  "http://lccn.loc.gov/n90694888", valueURI: "http://id.loc.gov/n9999999994")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :mads_name => {name: ["Updated Name"], sameAs:  ["http://lccn.loc.gov/n90694888"], valueURI: ["http://id.loc.gov/n9999999995"]}
	      response.should redirect_to assigns[:mads_name]
          @newobj = assigns[:mads_name]
	      #@obj.reload.name.should == ["Updated Name"]
	      @newobj.name.should == ["Updated Name"]
	      puts @obj.id
          pending "check title after reload #{__FILE__}"
	      flash[:notice].should == "Successfully updated personal name"
	    end
    end
  end
end

