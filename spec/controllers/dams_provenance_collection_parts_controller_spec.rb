require 'spec_helper'

describe DamsProvenanceCollectionPartsController do
  describe "A login user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
    	#DamsProvenanceCollectionPart.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsProvenanceCollectionPart.create(titleValue: "Test Provenance Collection Part Title", beginDate: "2012", endDate: "2013", visibility: "public", resource_type: "text")
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:dams_provenance_collection_part]
          @newobj.titleValue.should == @obj.titleValue
          @newobj.beginDate.should == @obj.beginDate
          @newobj.endDate.should == @obj.endDate
          @newobj.visibility.should == @obj.visibility
          @newobj.resource_type.should == @obj.resource_type
	    end
	  end
  end
end

