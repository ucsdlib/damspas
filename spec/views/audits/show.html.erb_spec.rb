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
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Action/)
    expect(rendered).to match(/Classname/)
    expect(rendered).to match(/Object/)
  end
end
