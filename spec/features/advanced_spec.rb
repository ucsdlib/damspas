require 'spec_helper'

describe "keyword field" do
  it "should prefilled the search term if the params exist" do
      visit '/advanced?q=fish'
      expect(page).to have_selector("input[value='fish']")
  end
end

describe "facet field" do
  it "should prefilled the facet if the facet params exist" do
      visit '/advanced?f[unit_sim][]=Library+Digital+Collections&f[object_type_sim][]=image'
      expect(page).to have_selector("input[id='f_inclusive_object_type_sim_image'][checked='checked']")
      expect(page).to have_selector("input[id='f_inclusive_unit_sim_Library_Digital_Collections'][checked='checked']")
  end
end

