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

  scenario 'visits a repository page' do
    visit dams_repository_path :id => 'bbXXXXXXX6'

    expect(page).to have_field('Search...')

    fill_in 'Search...', :with => '123'

    click_on('Search')

    ## This would be ideal:
    # expect(page).to have_content("")

    ##
    # But we'll do this for now:
    expect(page.current_url).to match /repository=bbXXXXXXX6/

  end
end