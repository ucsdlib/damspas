require 'spec_helper'

feature 'Visitor wants to look at digital collections' do
  scenario 'is on collections landing page' do
    @unit1 = DamsUnit.create(name: "Library Collections")
    @unit2 = DamsUnit.create(name: "RCI")

    visit dams_units_path
    expect(page).to have_selector('h1', :text => 'DAMS Administrative Units')
    expect(page).to have_selector('a', :text => 'Library Collections')
    expect(page).to have_selector('a', :text => 'RCI')
  end

end

feature 'Visitor should only see edit button when it will work' do
  scenario 'an anonymous user' do
    visit dams_unit_path('bb02020202')
    expect(page).not_to have_selector('a', :text => 'Edit')
  end
  scenario 'a logged in user' do
    sign_in_developer
    visit dams_unit_path('bb02020202')
    expect(page).to have_selector('a', :text => 'Edit')
  end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end

