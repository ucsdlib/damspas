require 'spec_helper'

describe MadsLanguagesController do
  describe "A logged-in user" do
	  before do
	  	sign_in User.create!
    	#DamsVocabularyEntry.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = MadsLanguage.create( code: "test", name: "Test Language" )
	    end
	    it "should be successful" do 
	      get :view, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:mads_language]
          @newobj.name.should == @obj.name
          @newobj.code.should == @obj.code
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:mads_language].should be_kind_of MadsLanguage
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = MadsLanguage.create(code: "test", name: "Test Language")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:mads_language]
          @newobj.code.should == @obj.code
          @newobj.name.should == @obj.name
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :mads_language => {code: "test", name: "Test Language"}
        }.to change { MadsLanguage.count }.by(1)
	      response.should redirect_to assigns[:mads_language]
	      assigns[:mads_language].should be_kind_of MadsLanguage
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = MadsLanguage.create(code: "test", name: "Test Language", scheme: ["bd71341600"])
 	    end

	    it "should be successful" do
	      put :update, :id => @obj.id, :mads_language => {code: ["test2"], name: ["Test Language 2"], scheme: ["bd71341600"]}
	      response.should redirect_to view_mads_language_path @obj.id
	      @newobj = assigns[:mads_language]
          @newobj.name.should == ["Test Language 2"]
          @newobj.code.should == ["test2"]
          @newobj.scheme.to_s.should == "http://library.ucsd.edu/ark:/20775/bd71341600"
	      flash[:notice].should == "Successfully updated language"
	    end
    end
  end
end

