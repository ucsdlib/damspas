require 'spec_helper'
require 'rack/test'

describe "Facets" do
  it "should display the constraints in the order in which they were selected" do
	visit catalog_index_path( {:q => 'sample'} )
	expect(page).to have_selector('div.pagination-note', :text => "Results 1 - 8 of 8")
	expect(page).to have_selector('span.dams-filter', :text => "sample")
	
	within "#facets" do
	  click_link "image"
	end	

	expect(page).to have_selector("span.selected", :text => "image 5")		
	expect(page).to have_selector('div.pagination-note', :text => "Results 1 - 5 of 5")
	
    page.all(:css, '.dams-filter').size.should eq(2)
	page.all('.dams-filter')[0].text.should include 'sample'
	page.all('.dams-filter')[1].text.should include 'image'
	
	within "#facets" do
	  click_link "UCSD Electronic Theses and Dissertations"
	end

	expect(page).to have_selector("span.selected", :text => "UCSD Electronic Theses and Dissertations 1")		
	expect(page).to have_selector('div.pagination-note', :text => "Results 1 to 1 of 1")
	
    page.all(:css, '.dams-filter').size.should eq(3)
	page.all('.dams-filter')[0].text.should include 'sample'
	page.all('.dams-filter')[1].text.should include 'image'
	page.all('.dams-filter')[2].text.should include 'UCSD Electronic Theses and Dissertations'
  end
end
