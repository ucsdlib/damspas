require 'spec_helper'

describe "pages/new" do
  before(:each) do
    assign(:page, stub_model(Page,
      :code => "MyString",
      :title => "MyString",
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", pages_path, "post" do
      assert_select "input#page_code[name=?]", "page[code]"
      assert_select "input#page_title[name=?]", "page[title]"
      assert_select "textarea#page_body[name=?]", "page[body]"
    end
  end
end
