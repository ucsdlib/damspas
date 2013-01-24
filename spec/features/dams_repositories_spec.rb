require 'spec_helper'

feature 'Visit wants to look at digital collections' do
  scenario 'is on collections landing page' do
    visit dams_repositories_path
    #expect(page).to have_selector('h1', :text => 'Digital Library Collections')
    expect(page).to have_selector('h1', :text => 'Digital Library Collections')
    #assert repository links on home page
    expect(page).to have_selector('a', :text => 'Library Collections')
    expect(page).to have_selector('a', :text => 'RCI')
  end
end