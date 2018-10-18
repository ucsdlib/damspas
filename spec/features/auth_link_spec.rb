require 'spec_helper'

feature 'Auth link' do
  let!(:user) { create_auth_link_user }

  scenario 'existing user requests sign in link' do
    visit new_auth_link_path

    fill_in 'Email', :with => 'test@example.com'
    click_on 'Send link'

    expect(page).to have_text("Email sent successfully! Check your inbox for the link")
  end

  scenario 'non-existing user requests sign in link' do
    visit new_auth_link_path

    fill_in 'Email', :with => 'fake@example.com'
    click_on 'Send link'

    expect(page).to have_text("User doesn't exist")
  end
end
