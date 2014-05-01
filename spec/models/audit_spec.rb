require 'spec_helper'

describe Audit do
  before do
    @audit = Audit.create!(user: "user@ucsd.edu", action: "create", classname: "DamsObject", object: "xx1234567x" )
    it "should have a user" do
      @audit.user.should == "user@ucsd.edu"
    end
    it "should have an action" do
      @audit.action.should == "create"
    end
    it "should have a classname" do
      @audit.classname.should == "DamsObject"
    end
    it "should have an object" do
      @audit.object.should == "xx1234567x"
    end
  end
end
