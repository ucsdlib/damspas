require 'spec_helper'

feature 'Visitor wants to look at collections' do
  scenario 'is on collections index page' do
    visit collections_path
    expect(page).to have_selector('h1', :text => 'Collections')
    expect(page).to have_selector('a', :text => 'Santa Fe Light Cone Simulation research project files')
  end

end
