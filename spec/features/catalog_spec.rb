require 'spec_helper'

feature 'Visitor wants to search' do
  scenario 'is on search results page' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h4', :text => 'Limit your search')
    expect(page).to have_selector('h3', :text => 'Sample Simple Object')
    expect(page).to have_selector("img.dams-search-thumbnail:first")
  end

end
