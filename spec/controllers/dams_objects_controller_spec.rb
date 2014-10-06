require 'spec_helper'
require 'net/http'
require 'json'

describe DamsObjectsController do
  describe "A login user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
	  	@obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013", copyrightURI: "bb05050505")
        solr_index @obj.id
	  end
	  describe "View" do
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful
	      @newobj = assigns[:dams_object]
          @newobj.titleValue.should == @obj.titleValue
          @newobj.beginDate.should == @obj.beginDate
	    end    
	  end
  end
end
