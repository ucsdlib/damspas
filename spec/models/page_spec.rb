require 'spec_helper'

describe Page do
  subject { Page.new }
  it "should have a code" do
    subject.code = "foo"
    expect(subject.code).to eq("foo")
  end
  it "should have a title" do
    subject.title = "Foo Page"
    expect(subject.title).to eq("Foo Page")
  end
  it "should have a body" do
    subject.body = "<p>Some markup.</p>"
    expect(subject.body).to eq("<p>Some markup.</p>")
  end
end
