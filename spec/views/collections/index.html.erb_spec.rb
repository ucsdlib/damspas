require 'spec_helper'

describe "collections/index.html.erb" do
  it "should have an h1 title" do
    render
    expect(rendered).to match /Digital Library Collections/
  end
end

