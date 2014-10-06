require 'spec_helper'

describe MadsPersonalNamesController do
  describe "A login user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
    	#MadsPersonalNameCollection.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = MadsPersonalName.create(name: "Personal Name Test ", externalAuthority: "http://lccn.loc.gov/n90694888")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:mads_personal_name]
          @newobj.name.should == @obj.name
          @newobj.externalAuthority.should == @obj.externalAuthority
	    end
	  end
  end
end

