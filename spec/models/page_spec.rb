require 'spec_helper'

describe Page do
  subject { Page.new }
  it "should have a code" do
    subject.code = "foo"
    subject.code.should == "foo"
  end
  it "should have a title" do
    subject.title = "Foo Page"
    subject.title.should == "Foo Page"
  end
  it "should have a body" do
    subject.body = "<p>Some markup.</p>"
    subject.body.should == "<p>Some markup.</p>"
  end
end
