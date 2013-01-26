require 'spec_helper'

feature 'Visit wants to look at digital collections' do
  scenario 'is on collections landing page' do
    visit dams_repositories_path
    #expect(page).to have_selector('h1', :text => 'Digital Library Collections')
    expect(page).to have_selector('h1', :text => 'Digital Library Collections')
    #assert repository links on home page
    expect(page).to have_selector('a', :text => 'Library Collections')
    expect(page).to have_selector('a', :text => 'RCI')

    expect(page).to have_field('Search...')
  end

  scenario 'does a search for items' do
    visit dams_repositories_path


    expect(page).to have_selector('h2', :text => 'Search')

    fill_in 'Search...', :with => "123"

    click_on('Search')


    expect(page).to have_content('Search Results')

  end

  scenario 'browses the collections' do
    visit dams_repositories_path

    expect(page).to have_selector('h2', :text => 'Browse')

    expect(page).to have_selector('a', :text => 'By Topic')
    expect(page).to have_selector('a', :text => 'By Repository')
    expect(page).to have_selector('a', :text => 'By Format')
  end

  scenario 'uses the carousel' do
    visit dams_repositories_path

    expect(page).to have_selector('.carousel')
  end

  scenario 'retrieve a repository record' do
    sign_in_developer
    DamsRepository.create! pid: "bb45454545", name: "RCI", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://library.ucsd.edu/repo/rci/"

    # can we find the repository record
    expect(page).to have_field('Search...')
    fill_in 'Search...', :with => 'bb45454545'

    click_on('Search')

    # Check description on the page
    #expect(page).to have_content("bb45454545")
    expect(page).to have_content("RCI")



  end

  scenario 'scoped search'
    # create a repo
    #sign_in_developer
    #DamsRepository.create! pid: "bb45454545", name: "RCI", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://library.ucsd.edu/repo/rci/"

    # create an object in the repo
    #DamsRepository.create! pid: "bb45454545", name: "RCI", description: "Research Cyberinfrastructure: the hardware, software, and people that support scientific research.", uri: "http://library.ucsd.edu/repo/rci/"
    #visit dams_repository_path :id => 'bb45454545'
    # searchfor the object inthe repo and find it
end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
