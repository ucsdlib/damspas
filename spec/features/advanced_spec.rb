require 'spec_helper'

describe "keyword field" do
  it "should prefilled the search term if the params exist" do
      visit '/advanced?q=fish'
      expect(page).to have_selector("input[value='fish']")
  end
end