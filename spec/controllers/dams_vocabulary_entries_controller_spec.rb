require 'spec_helper'

describe DamsVocabularyEntriesController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	#DamsVocabularyEntry.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsVocabularyEntry.create(value: "Vocabulary Entry value", vocabulary: "http://library.ucsd.edu/ark:/20775/bb43434343")
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_vocabulary_entry].should == @obj
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_vocabulary_entry].should be_kind_of DamsVocabularyEntry
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = DamsVocabularyEntry.create(value: "Vocabulary Entry test update", vocabulary: "http://library.ucsd.edu/ark:/20775/bb43434343")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_vocabulary_entry].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :dams_vocabulary_entry => {value: ["Test Title"],vocabulary: "http://library.ucsd.edu/ark:/20775/bb43434343"}
        }.to change { DamsVocabularyEntry.count }.by(1)
	      response.should redirect_to assigns[:dams_vocabulary_entry]
	      assigns[:dams_vocabulary_entry].should be_kind_of DamsVocabularyEntry
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = DamsVocabularyEntry.create(value: "Vocabulary Entry Test Title", vocabulary: "http://library.ucsd.edu/ark:/20775/bb43434343")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :dams_vocabulary_entry => {value: ["Test Title2"], vocabulary: ["http://library.ucsd.edu/ark:/20775/bb43434343"]}
	      response.should redirect_to assigns[:dams_vocabulary_entry]
	      @newobj = assigns[:dams_vocabulary_entry]
          @newobj.value.should == ["Test Title2"]
	      flash[:notice].should == "Successfully updated vocabulary entry"
	    end
    end
  end
end

