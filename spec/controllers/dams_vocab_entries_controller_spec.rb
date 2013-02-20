require 'spec_helper'

describe DamsVocabEntriesController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
    	DamsVocabEntry.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsVocabEntry.create(value: "Vocab Entry value", vocabulary: "http://library.ucsd.edu/ark:/20775/bb43434343")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_vocab_entry].should == @obj
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_vocab_entry].should be_kind_of DamsVocabEntry
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = DamsVocabEntry.create(value: "Vocab Entry test update", vocabulary: "http://library.ucsd.edu/ark:/20775/bb43434343")
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_vocab_entry].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :dams_vocab_entry => {value: ["Test Title"]}
        }.to change { DamsVocabEntry.count }.by(1)
	      response.should redirect_to assigns[:dams_vocab_entry]
	      assigns[:dams_vocab_entry].should be_kind_of DamsVocabEntry
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = DamsVocabEntry.create(value: "Vocab Entry Test Title", vocabulary: "http://library.ucsd.edu/ark:/20775/bb43434343")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :dams_vocab_entry => {value: ["Test Title2"], vocabulary: ["http://library.ucsd.edu/ark:/20775/bb43434343"]}
	      response.should redirect_to assigns[:dams_vocab_entry]
	      @obj.reload.value.should == ["Test Title2"]
	      flash[:notice].should == "Successfully updated vocab entry"
	    end
    end
  end
end

