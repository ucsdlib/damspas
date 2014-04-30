require 'spec_helper'

describe "audits/show" do
  before(:each) do
    @audit = assign(:audit, stub_model(Audit,
      :description => "Description",
      :user => "User",
      :object => "Object"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    rendered.should match(/User/)
    rendered.should match(/Object/)
  end
end
