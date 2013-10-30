require 'spec_helper'

feature 'Access control' do
  scenario 'anonymous user searching' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h3', 'Sample Simple Object: An Image Object')
    expect(page).to have_no_content('Sample Video Object')
  end
  scenario 'anonymous user viewing public object' do
    visit dams_object_path 'bd22194583'
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
  scenario 'anonymous user viewing restricted object' do
    visit dams_object_path 'bd0922518w'
    expect(page).to have_selector('h1','You are not allowed to view this page.')
    expect(page).to have_no_content('Sample Complex Object Record #3')
  end
  scenario 'curator user searching' do
    sign_in_developer
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h3', 'Sample Simple Object: An Image Object')
    expect(page).to have_selector('h3', 'Sample Video Object')
  end
  scenario 'curator user viewing public object' do
    sign_in_developer
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
  scenario 'curator user viewing restricted object' do
    sign_in_developer
    visit dams_object_path 'bd0922518w'
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end

