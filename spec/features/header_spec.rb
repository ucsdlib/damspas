require 'spec_helper'

feature 'Visitor go to damspas should' do
  scenario 'see Statistics link' do
    visit root_path
    expect(page).to have_link('Statistics', 'https://library.ucsd.edu/damsmanager/stats.do')
  end

  scenario 'see About link' do
    visit root_path
    expect(page).to have_link('Digital Collections', view_page_path('about'))
  end
end