require 'spec_helper'

describe Ability do
  describe "Anonymous user" do
    before do
      @obj = DamsObject.create!(titleValue: "Test Title")
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
    before do
      @obj = DamsObject.create!(titleValue: "Test Title")
    end
    subject do
      Ability.new(User.create!)
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
  end
end
