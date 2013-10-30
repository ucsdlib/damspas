require 'spec_helper'

feature 'Visitor wants to look at units' do
  scenario 'is on units landing page' do
    visit dams_units_path
    expect(page).to have_selector('h3', :text => 'Library Digital Collections')
    expect(page).to have_selector('h3', :text => 'Research Cyberinfrastructure')
    expect(page).to have_selector('a', :text => 'Collection')
    expect(page).to have_selector('a', :text => 'Format')
    expect(page).to have_selector('a', :text => 'Topic')

    expect(page).to have_field('Search...')
  end

  scenario 'does a search for items' do
    sign_in_developer
    visit dams_units_path

    fill_in 'Search...', :with => "Sample Complex Object Record #3", :match => :prefer_exact
    click_on('search-button')

    expect(page).to have_content('Search Results')
    expect(page).to have_content('Limit your search')
    expect(page).to have_content('Sample Complex Object Record #3: Format Sampler')
  end

  scenario 'retrieve a unit record' do
    # can we find the unit record
    sign_in_developer
    visit dams_units_path
    expect(page).to have_field('Search...')
    fill_in 'Search...', :with => 'bb02020202', :match => :prefer_exact

    click_on('search-button')

    # Check description on the page
    expect(page).to have_content("bb02020202")
  end

  scenario 'unit pages should have scoped browse links' do
    visit dams_unit_path :id => 'dlp'
    expect(page).to have_selector('h1', :text => 'Library Digital Collections')

    # browse links should be scoped to the unit
    topiclink = find('ul.sidebar-button-list li a', text: "Topic")
    expect(topiclink[:href]).to have_content('dlp')
  end

  scenario 'scoped search (inclusion)' do
    # search for the object in the unit and find it
    visit catalog_index_path( {'f[unit_sim][]' => 'Library Digital Collections', :q => 'sample'} )
    expect(page).to have_content('Search Results')
    expect(page).to have_content('Sample Simple Object')
  end

  scenario 'scoped search (exclusion)' do
    visit dams_unit_path :id => 'rci'
    expect(page).to have_selector('h1', :text => 'Research Data Curation Program')

    # search for the object in the unit and find it
    visit catalog_index_path( {'f[unit_sim][]' => 'Research+Data+Curation+Program', :q => 'sample'} )
    expect(page).to have_no_content('Sample Simple Object')
  end
end
feature 'Visitor should only see edit button when it will work' do
  scenario 'an anonymous user' do
    visit dams_unit_path('dlp')
    expect(page).not_to have_selector('a', :text => 'Edit')
  end
  scenario 'a logged in user' do
    sign_in_developer
    visit dams_unit_path('dlp')
    expect(page).to have_selector('a', :text => 'Edit')
  end
end

feature 'Visitor should only see edit button when it will work' do
  scenario 'an anonymous user' do
    visit dams_unit_path('dlp')
    expect(page).not_to have_selector('a', :text => 'Edit')
  end
  scenario 'a logged in user' do
    sign_in_developer
    visit dams_unit_path('dlp')
    expect(page).to have_selector('a', :text => 'Edit')
  end
end

feature "Visitor wants to view the unit's collections" do
  scenario 'an anonymous user' do
    visit dams_unit_collections_path('dlp')
    expect(page).to have_selector('h3','Browse by Collection: Library Digital Collections')
    expect(page).to have_selector('a', :text => 'UCSD Electronic Theses and Dissertations')
    expect(page).to have_selector('li', :text => 'Linked scope content note')
  end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end

