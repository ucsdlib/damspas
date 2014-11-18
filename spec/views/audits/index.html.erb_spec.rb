require 'spec_helper'

describe "audits/index" do
  before(:each) do
    assign(:audits, Kaminari.paginate_array([
      stub_model(Audit,
        :user => "User",
        :action => "Action",
        :classname => "Classname",
        :object => "Object"
      ),
      stub_model(Audit,
        :user => "User",
        :action => "Action",
        :classname => "Classname",
        :object => "Object"
      )
    ]).page(1))
  end

  it "renders a list of audits" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Action".to_s, :count => 2
    assert_select "tr>td", :text => "Classname".to_s, :count => 2
    assert_select "tr>td", :text => "Object".to_s, :count => 2
  end
end
