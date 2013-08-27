require 'spec_helper'

feature 'Visitor wants to look at units' do
  scenario 'is on units landing page' do
    visit dams_units_path
    expect(page).to have_selector('h1', :text => 'Digital Collections')
    expect(page).to have_selector('a', :text => 'Library Digital Collections')
    expect(page).to have_selector('a', :text => 'Research Data Curation Program')
    expect(page).to have_selector('p', :text => 'Browse')
    expect(page).to have_selector('a', :text => 'Topic')
    expect(page).to have_selector('a', :text => 'Format')

    expect(page).to have_field('Search DAMS')
  end

  scenario 'does a search for items' do
    visit dams_units_path

    fill_in 'Search DAMS', :with => "sample", :match => :prefer_exact
    click_on('search-button')

    expect(page).to have_content('Search Results')
    expect(page).to have_content('Limit your search')
    expect(page).to have_content('Sample Complex Object Record #3: Format Sampler')
  end

  scenario 'uses the carousel' do
    visit dams_units_path

    expect(page).to have_selector('.carousel')
  end

  scenario 'retrieve a unit record' do
    # can we find the unit record
    visit dams_units_path
    expect(page).to have_field('Search DAMS')
    fill_in 'Search DAMS', :with => 'bb02020202', :match => :prefer_exact

    click_on('search-button')

    # Check description on the page
    expect(page).to have_content("bb02020202")
  end

  scenario 'scoped search (inclusion)' do
    visit dams_unit_path :id => 'dlp'
    expect(page).to have_selector('h1', :text => 'Library Digital Collections')

    # search for the object in the unit and find it
    fill_in 'Search DAMS', :with => 'sample', :match => :prefer_exact
    click_on('search-button')
    expect(page).to have_content('Search Results')
    expect(page).to have_content('Sample Complex Object Record #3')
  end

  scenario 'scoped search (exclusion)' do
    visit dams_unit_path :id => 'rci'
    expect(page).to have_selector('h1', :text => 'Research Data Curation Program')

    # search for the object in the unit and find it
    fill_in 'Search DAMS', :with => 'sample', :match => :prefer_exact
    click_on('search-button')
    expect(page).to have_content('Search Results')
    expect(page).to have_no_content('Sample Complex Object Record #1')
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
    expect(page).to have_selector('a', :text => 'UCSD Electronic Theses and Dissertations')
  end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end

