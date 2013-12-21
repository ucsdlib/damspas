require 'spec_helper'
require 'net/http'
require 'json'

describe DamsObjectsController do
  describe "A login user" do
	  before do
	    @user = User.create!
	    @user_groups = @user.groups	    
	    @bak_user_groups = [];
	    @user_groups.each do |g|
	    	@bak_user_groups << g
	    end
	  	sign_in @user
	  end
	  describe "View" do
	    before do
	      @user_groups << Rails.configuration.super_role
	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013", copyrightURI: "bb05050505")
	      #puts @obj.id
	      # reindex the record
	      solr_index @obj.id
	    end
	    it "should be successful" do 
	      get :view, id: @obj.id
	      response.should be_successful
	      @newobj = assigns[:dams_object]
          @newobj.titleValue.should == @obj.titleValue
          @newobj.beginDate.should == @obj.beginDate
	    end
		describe "in Gated Access Control" do
		  	before do
		  		@user_groups.clear
		  	end
		  	it "should not be successful with no curator roles assigned" do
		  		get :view, id: @obj.id
		  		response.should_not be_successful 
		  	end
		  	it "should not be successful for the non RCI unit record with a dams-rci unit role assigned" do
		  		@user_groups << "dams-rci"
		  		get :view, id: @obj.id
		  		response.should_not be_successful 
		  	end
		  	it "should be successful with a #{Rails.configuration.super_role} assigned" do
		  		@user_groups.clear
		  		@user_groups << Rails.configuration.super_role
		  		get :view, id: @obj.id
		  		response.should be_successful 
		  	end
		 end
		 after do
		  	@user_groups.clear;
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
	  	    logger.debug("[CANCAN rspec user roles after reset: #{@user.groups.inspect}]")
		  end	    
	  end
	  
	  describe "New" do
	    before do
	      @user_groups << Rails.configuration.super_role
	    end
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_object].should be_kind_of DamsObject
	    end
		 after do
		  	@user_groups.clear;
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
	  	    logger.debug("[CANCAN rspec user roles after reset: #{@user.groups.inspect}]")
		  end
	  end
	  
	  describe "Edit" do
	    before do
	      @user_groups << Rails.configuration.super_role
	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013", copyrightURI: "bb05050505")
	      # reindex the record
	      solr_index @obj.id
	    end
	    it "should be successful" do
	      get :edit, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:dams_object]
          @newobj.titleValue.should == @obj.titleValue
          @newobj.beginDate.should == @obj.beginDate
	    end
		describe "in Gated Access Control" do
		  	before do
		  		@user_groups.clear
		  	end
		  	it "should not be successful with no curator roles assigned" do
		  		get :edit, id: @obj.id
		  		response.should_not be_successful 
		  	end
		  	it "should not be successful for the non RCI unit record with a dams-rci unit role assigned" do
		  		@user_groups << "dams-rci"
		  		get :edit, id: @obj.id
		  		response.should_not be_successful 
		  	end
		  	it "should be successful with a #{Rails.configuration.super_role} assigned" do
		  		@user_groups << Rails.configuration.super_role
		  		get :edit, id: @obj.id
		  		response.should be_successful 
		  	end
		 end
		 after do
		  	@user_groups.clear;
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
	  	    logger.debug("[CANCAN rspec user roles after reset: #{@user.groups.inspect}]")
		  end
	  end
	  
	  describe "Create" do
	    before do
	      @user_groups << Rails.configuration.super_role
	    end
	    
	    it "should be successful" do
	      expect { 
	       #post :create, :dams_object => {titleValue: ["Test Title"], "subjectType"=>["Topic","BuiltWorkPlace","Temporal"], "subjectTypeValue"=>["testTopicValue","testWorkplaceValue1","testTemporal"]}	      
	       #post :create, :dams_object => {titleValue: ["Test Title"], beginDate: ["2013"], typeOfResource: ["text"], subjectValue: ["subjectValue1", "subjectValue2"]}
	       #post :create, :dams_object => {titleValue: ["Test Title"], relationshipRoleURI: ["bb0376727p"], relationshipNameURI: ["xx00010235"], relationshipNameType: ["CorporateName"]}
	       #post :create, :dams_object => {titleValue: ["Test Title"], relationshipRoleURI: [""], relationshipNameType: [""]}
	       #post :create, :dams_object => {titleValue: ["Test Title"], relationshipRoleURI: ["xx00000544"], relationshipNameValue: ["V6"], relationshipNameType: ["PersonalName"]}
		   post :create, :dams_object => {"title_attributes"=>{"0"=>{mainTitleElement_attributes: [{ elementValue: "Sample Complex Object Record #1" }]}},"copyright_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/bb05050505"}]}
		   #puts assigns[:dams_object].pid
        }.to change { DamsObject.count }.by(1)
	      response.should redirect_to assigns[:dams_object]
	      assigns[:dams_object].should be_kind_of DamsObject
	    end
		describe "in Gated Access Control" do
		  	before do
		  		@user_groups.clear
		  	end
		  	it "should not be successful with no curator roles assigned" do
		  		expect {
		   			post :create, :dams_object => {titleValue: ["Test Title"],"unitURI"=>["bb02020202"]}
		  		}.to change { DamsObject.count }.by(0)
		  	end
		  	it "should be successful with a #{Rails.configuration.super_role} assigned" do
		  		@user_groups.clear
		  		@user_groups << Rails.configuration.super_role
		  		expect {
		   			post :create, :dams_object => {titleValue: ["Test Title"],"unitURI"=>["bb02020202"]}
		  		}.to change { DamsObject.count }.by(1)
		  	end
		 end
		 after do
		  	@user_groups.clear;
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
	  	    logger.debug("[CANCAN rspec user roles after reset: #{@user.groups.inspect}]")
		  end
	  end
	  
	  describe "Update" do
	    before do
	      @user_groups << 'dams-manager-admin'
 	      @obj = DamsObject.create(titleValue: "Original Title", beginDate: "2012", copyrightURI: "bb05050505")
 	      # reindex the record
	      solr_index @obj.id
 	    end
	    it "should be successful" do
	      
	      put :update, :id => @obj.id, :dams_object => {titleValue:"Updated Title", beginDate: ["2013"]}
	      response.should redirect_to assigns[:dams_object]
          @newobj = assigns[:dams_object]
	      @newobj.titleValue.should == "Updated Title"
	      @newobj.beginDate.should == ["2013"]
	      flash[:notice].should == "Successfully updated object"
	    end
		describe "in Gated Access Control" do
		  	before do
		  		@user_groups.clear
		  	end
		  	it "should not be successful with no curator roles assigned" do
		  		put :update, :id => @obj.id, :dams_object => {titleValue:"Updated Title", beginDate: ["2013"]}
		  		response.should_not redirect_to assigns[:dams_object] 
		  	end
		  	it "should not be successful for the non RCI unit record with a dams-rci unit role assigned" do
		  		@user_groups << "dams-rci"
		  		put :update, :id => @obj.id, :dams_object => {titleValue:"Updated Title", beginDate: ["2013"]}
		  		response.should_not redirect_to assigns[:dams_object]
		  	end
		  	it "should be successful with a #{Rails.configuration.super_role} assigned" do
		  		@user_groups << Rails.configuration.super_role
		  		put :update, :id => @obj.id, :dams_object => {titleValue:"Updated Title", beginDate: ["2013"]}
		  		response.should redirect_to assigns[:dams_object]
		  		flash[:notice].should == "Successfully updated object" 
		  	end
		 end
		 after do
		  	@user_groups.clear;
		  	@bak_user_groups.each do |g|
	    		@user_groups << g
	    	end
		  	logger.debug("[CANCAN rspec user roles reset: #{@user.groups.inspect}]")
		  end
    end
  end
end
