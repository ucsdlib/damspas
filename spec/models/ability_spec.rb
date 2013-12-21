require 'spec_helper'

describe Ability do
  describe "Anonymous user" do
    before do
      @obj = DamsObject.create!(titleValue: "Test Title")
 	  # reindex the record
	  solr_index @obj.id
    end
    subject do
      Ability.new(User.new)
    end
    it "should not be able to show damsObject" do
      subject.can?(:show,@obj).should be_false
    end
    it "should not be able to create damsObject" do
      subject.can?(:create,@obj).should be_false
    end
    
    it "should not be able to edit damsObject" do
      subject.can?(:edit,@obj).should be_false
    end
    
    it "should not be able to update damsObject" do
      subject.can?(:update,@obj).should be_false
    end
  end
  
  describe "a logged in user" do
    describe "#{Rails.configuration.super_role} (super user)" do 
	    before do
	      @obj = DamsObject.create!(titleValue: "Test Title", unitURI:"bb02020202", copyrightURI: "bb05050505")
	      # reindex the record
		  solr_index @obj.id
	    end
	    subject do
	      @user = User.create!
	      @user.groups << Rails.configuration.super_role
	      Ability.new(@user)
	    end
	    it "should be able to show damsObject" do
	      subject.can?(:show,@obj).should == true
	    end
	    it "should be able to create damsObject" do
	      subject.can?(:create,@obj).should be_true
	    end
	    it "should be able to edit damsObject" do
	      subject.can?(:edit,@obj).should be_true
	    end
	    it "should be able to update damsObject" do
	      subject.can?(:update,@obj).should be_true
	    end
	    after do
	    	@user.groups.delete(Rails.configuration.super_role)
	    end
    end
    
    describe "dams-rci (rci unit curator)" do 
	    before do
	      @obj = DamsObject.create!(titleValue: "Test Title", unitURI: "bb02020202", copyrightURI: "bb05050505")
	      # reindex the record
		  solr_index @obj.id
	    end
	    subject do
	      @user = User.create!
	      @user.groups << "dams-rci"
	      Ability.new(@user)
	    end
	    it "should not be able to show a dlp damsObject" do
	      subject.can?(:show,@obj).should be_false
	    end
	    it "should not be able to create a dlp damsObject" do
	      subject.can?(:create,@obj).should be_false
	    end
	    it "should not be able to edit dlp damsObject" do
	      subject.can?(:edit,@obj).should be_false
	    end
	    it "should not be able to update a dlp damsObject" do
	      subject.can?(:update,@obj).should be_false
	    end
	    after do
	    	@user.groups.delete("dams-rci")
	    end
    end
  end
end
