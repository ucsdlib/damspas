require 'spec_helper'

describe "pages/index" do
  before(:each) do
    assign(:pages, [
      stub_model(Page,
        :code => "code1",
        :title => "Page Title",
        :body => "<p>Page text.</p>"
      ),
      stub_model(Page,
        :code => "code2",
        :title => "Page Title",
        :body => "<p>Page text.</p>"
      )
    ])
    sign_in User.create!( {:provider => 'developer'} )
  end

  it "renders a list of pages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "code1".to_s, :count => 1
    assert_select "tr>td", :text => "code2".to_s, :count => 1
    assert_select "tr>td", :text => "Page Title".to_s, :count => 2
  end
end
