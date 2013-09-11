require 'spec_helper'

feature 'Visitor wants to search' do
  scenario 'is on search results page' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h4', :text => 'Limit your search')
    expect(page).to have_selector('h3', :text => 'Sample Simple Object')
    expect(page).to have_selector("img.dams-search-thumbnail:first")
    expect(page).to have_selector("a.dams-search-thumbnail-link:first")
  end
  scenario 'is on a browse results page' do
    # should show links to remove facets, even when there is no query
    visit catalog_index_path( {'f[unit_sim][]' => 'Library Digital Collections'} )
    expect(page).to have_selector("div.dams-search-constraints")
    expect(page).to have_selector("span.dams-filter")
  end
  scenario 'results sorted by object creation date' do
    visit catalog_index_path( {'f[unit_sim][]' => 'Library Digital Collections', 'sort' => 'object_create_dtsi asc'} )
    idx1 = page.body.index('Sample Audio Object: I need another')   # no date
    idx2 = page.body.index('The real thing')                        # 2012-09-01
    idx3 = page.body.index('Sample Simple Object: An Image Object') # 2012-04-08
    idx3.should >( idx2 )
    idx2.should >( idx1 )
  end
  scenario 'results sorted by object creation date' do
    visit catalog_index_path( {'f[unit_sim][]' => 'Library Digital Collections', 'sort' => 'object_create_dtsi asc'} )
    click_on "Sample Data Object"
    expect(page).to have_selector('a', :text => "Previous")
    expect(page).to have_selector('a', :text => "Next")
  end
end
