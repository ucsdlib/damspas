require 'spec_helper'

describe Ability do
  describe "Anonymous user" do
    before do
      @obj = DamsObject.create!(title: "Test Title")
    end
    subject do
      Ability.new(User.new)
    end
    it "should be able to show damsObject" do
      subject.can?(:show,@obj).should == true

    end
  end
end
