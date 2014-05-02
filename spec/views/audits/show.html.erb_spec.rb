require 'spec_helper'

describe "audits/show" do
  before(:each) do
    @audit = assign(:audit, stub_model(Audit,
      :user => "User",
      :action => "Action",
      :classname => "Classname",
      :object => "Object"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User/)
    rendered.should match(/Action/)
    rendered.should match(/Classname/)
    rendered.should match(/Object/)
  end
end
