require 'spec_helper'

feature 'Visitor wants to look at collections' do
  scenario 'is on collections index page' do
    visit collections_path
    expect(page).to have_selector('h1', :text => 'Collections')
    expect(page).to have_selector('a', :text => 'Scripps Institution of Oceanography, Geological Collections')
    expect(page).to have_selector('a', :text => 'Santa Fe Light Cone Simulation research project files 2005-2012, Bulk 2005-2007')
  end

end
