require 'spec_helper'

feature 'Visitor wants to look at collections' do
  scenario 'is on collections index page' do
    visit dams_collections_path
    
    expect(page).to have_selector('h3', :text => 'Collections')
    

    expect(page).to have_selector('a', :text => 'Scripps Institution of Oceanography, Geological Collections')
    expect(page).to have_selector('a', :text => 'Santa Fe Light Cone Simulation research project files 2005-2012, Bulk 2005-2007')
  end
  scenario 'public collections list' do
    visit catalog_facet_path('collection_sim')
    pending("access control enforcement")
    expect(page).not_to have_selector('a', :text => 'curator-only collection')
  end
  scenario 'curator collections list' do
    sign_in_developer
    visit catalog_facet_path('collection_sim')
    expect(page).to have_selector('a', :text => 'curator-only collection')
  end

  scenario 'collections search without query' do
    visit collection_search_path
    expect(page).to have_selector('a', :text => 'Sample Assembled Collection')
    expect(page).to have_selector('a', :text => 'Sample Provenance Collection')
  end
  scenario 'collections search without query' do
    visit collection_search_path( {:q => 'assembled'} )
    expect(page).to have_selector('a', :text => 'Sample Assembled Collection')
    expect(page).not_to have_selector('a', :text => 'Sample Provenance Collection')
  end

end
def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end

