require 'spec_helper'

feature 'Visit wants to look at digital collections' do
  scenario 'is on collections landing page' do
    @unit1 = DamsUnit.create(name: "Library Collections")
    @unit2 = DamsUnit.create(name: "RCI")

    visit dams_units_path
    #expect(page).to have_selector('h1', :text => 'Digital Library Collections')
    expect(page).to have_selector('h1', :text => 'Digital Library Collections')
    #assert unit links on home page
    expect(page).to have_selector('a', :text => 'Library Collections')
    expect(page).to have_selector('a', :text => 'RCI')

    expect(page).to have_field('Search...')
  end

  scenario 'does a search for items' do
    visit dams_units_path


    expect(page).to have_selector('h2', :text => 'Search')

    fill_in 'Search...', :with => "123"

    click_on('Search')


    expect(page).to have_content('Search Results')

  end

  scenario 'browses the collections' do
    visit dams_units_path

    expect(page).to have_selector('h2', :text => 'Browse')

    expect(page).to have_selector('a', :text => 'By Topic')
    expect(page).to have_selector('a', :text => 'By Unit')
    expect(page).to have_selector('a', :text => 'By Format')
  end

  scenario 'uses the carousel' do
    visit dams_units_path

    expect(page).to have_selector('.carousel')
  end

  scenario 'retrieve a unit record' do
    sign_in_developer
    DamsUnit.create! pid: "bb45454545", name: "RCI", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://rci.ucsd.edu/", code: "rci"

    # can we find the unit record
    visit dams_units_path
    expect(page).to have_field('Search...')
    fill_in 'Search...', :with => 'bb45454545'

    click_on('Search')

    # Check description on the page
    expect(page).to have_content("bb45454545")
    #expect(page).to have_content("RCI")



  end

  scenario 'scoped search'
    # create a unit
    #sign_in_developer
    #DamsUnit.create! pid: "bb45454545", name: "RCI", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://rci.ucsd.edu/"

    # create an object in the unit
    #DamsUnit.create! pid: "bb45454545", name: "RCI", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://rci.ucsd.edu/"
    #visit dams_unit_path :id => 'bb45454545'
    # search for the object in the unit and find it
end
