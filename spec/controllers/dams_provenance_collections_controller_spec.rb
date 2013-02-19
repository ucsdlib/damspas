require 'spec_helper'

describe DamsProvenanceCollectionsController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	DamsProvenanceCollection.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsProvenanceCollection.create(title: "Provenance Collection Test Title", beginDate: "2012", endDate: "2013")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_provenance_collection].should == @obj
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_provenance_collection].should be_kind_of DamsProvenanceCollection
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = DamsProvenanceCollection.create(title: "Provenance Collection Test Title", beginDate: "2012", endDate: "2013")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_provenance_collection].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :dams_provenance_collection => {title: ["Test Title"], date: ["2013"]}
        }.to change { DamsProvenanceCollection.count }.by(1)
	      response.should redirect_to assigns[:dams_provenance_collection]
	      assigns[:dams_provenance_collection].should be_kind_of DamsProvenanceCollection
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = DamsProvenanceCollection.create(title: "Provenance Collection Test Title", beginDate: "2012", endDate: "2013")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :dams_provenance_collection => {title: ["Test Title2"], beginDate: ["2013"]}
	      response.should redirect_to assigns[:dams_provenance_collection]
	      @obj.reload.title.should == ["Test Title2"]
	      flash[:notice].should == "Successfully updated provenance collection"
	    end
    end
  end
end

