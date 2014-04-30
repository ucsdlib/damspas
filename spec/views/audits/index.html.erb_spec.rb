require 'spec_helper'

describe "audits/index" do
  before(:each) do
    assign(:audits, [
      stub_model(Audit,
        :description => "Description",
        :user => "User",
        :object => "Object"
      ),
      stub_model(Audit,
        :description => "Description",
        :user => "User",
        :object => "Object"
      )
    ])
  end

  it "renders a list of audits" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Object".to_s, :count => 2
  end
end
