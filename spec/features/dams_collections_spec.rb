require 'spec_helper'

feature 'Visitor wants to look at collections' do
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
  scenario 'recursive colleciton membership' do
    sign_in_developer
    visit catalog_index_path({'f[collection_sim][]' => 'UCSD Electronic Theses and Dissertations'})
    expect(page).to have_selector('a', :text => 'Test Object in Provenance Collection')
    expect(page).to have_selector('a', :text => 'Test Object in Provenance Collection Part')
  end

  scenario 'collections search without query' do
    visit dams_collections_path
    expect(page).to have_selector('a', :text => 'Sample Assembled Collection')
    expect(page).to have_selector('a', :text => 'Sample Provenance Collection')
  end
  scenario 'collections search without query' do
    visit dams_collections_path( {:q => 'assembled'} )
    expect(page).to have_selector('a', :text => 'Sample Assembled Collection')
    expect(page).to have_selector('img.dams-search-thumbnail')
    expect(page).not_to have_selector('a', :text => 'Sample Provenance Collection')
  end
  scenario 'curator view' do
    sign_in_developer
    visit dams_collection_path 'bd5905304g' # santa fe light cone
    expect(page).to have_link('View RDF document')
  end
end
def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end

