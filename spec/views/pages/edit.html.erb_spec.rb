require 'spec_helper'

describe "pages/edit" do
  before(:each) do
    @page = assign(:page, stub_model(Page,
      :code => "MyString",
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", page_path(@page), "post" do
      assert_select "input#page_code[name=?]", "page[code]"
      assert_select "input#page_title[name=?]", "page[title]"
      assert_select "textarea#page_body[name=?]", "page[body]"
    end
  end
end
