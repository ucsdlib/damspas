require 'spec_helper'

feature 'Visit wants to look at digital collections' do
  scenario 'is on collections landing page' do
    @unit1 = DamsUnit.create(name: "Library Collections")
    @unit2 = DamsUnit.create(name: "RCI")

    visit dams_units_path
    expect(page).to have_selector('h1', :text => 'DAMS Administrative Units')
    expect(page).to have_selector('a', :text => 'Library Collections')
    expect(page).to have_selector('a', :text => 'RCI')
  end

end
