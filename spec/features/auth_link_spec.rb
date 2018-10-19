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

  scenario 'requesting a sign in link w/ invalid email format' do
    visit new_auth_link_path

    fill_in 'Email', :with => ''
    click_on 'Send link'

    expect(page).to have_text("User doesn't exist")
  end

  scenario 'user can sign in with a valid email and auth token' do
    visit new_user_session_path(email: user.email, auth_token: user.authentication_token)

    expect(page).to have_text("Successfully authenticated from email account")
  end

  scenario 'user cannot sign in without a valid email and auth token' do
    visit new_user_session_path(email: 'fake@example.com', auth_token: 'hacker')

    expect(page).to have_text("Authentication failed: Your credentials were invalid")
  end

  scenario 'user can sign out after signing in with a auth token' do
    visit new_user_session_path(email: user.email, auth_token: user.authentication_token)
    visit destroy_user_session_path

    expect(page).to have_text("You have been logged out of Digital Collections")
  end

  scenario 'user who is already signed in via auth token cannot sign in via another method' do
    visit new_user_session_path(email: user.email, auth_token: user.authentication_token)
    visit new_user_session_path

    expect(page).to have_text("You are already signed in")

    visit new_user_session_path(email: user.email, auth_token: user.authentication_token)

    expect(page).to have_text("You are already signed in")
  end

  scenario 'sends an email if credentials are valid' do
    event = AuthMailer.send_link(user)

    visit new_user_session_path(email: user.email, auth_token: user.authentication_token)

    expect { event.deliver_later }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
