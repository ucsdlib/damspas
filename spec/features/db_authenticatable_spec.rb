require 'spec_helper'

feature "User can login" do
  scenario "using an email and password" do
    create_db_authenticatable_user
    visit new_user_email_session_path

    fill_in "Email", :with => "test@example.com"
    fill_in "Password", :with => "password"
    click_button "Log in"

    expect(page).to have_text("Signed in successfully")
  end

  scenario "as a developer" do
    sign_in_developer
    expect(page).to have_text("Successfully authenticated from Developer account")
  end
end

feature "User can logout" do
  scenario "of a db_authenticatable user" do
    create_db_authenticatable_user
    visit new_user_email_session_path

    fill_in "Email", :with => "test@example.com"
    fill_in "Password", :with => "password"
    click_button "Log in"

    visit destroy_user_session_path

    expect(page).to have_text("You have been logged out of Digital Collections")
  end

  scenario "of a developer account" do
    sign_in_developer
    visit destroy_user_session_path

    expect(page).to have_text("You have been logged out of Digital Collections")
  end
end

feature "User can reset their password" do
  scenario "via sending a reset request to their email" do
    create_db_authenticatable_user
    visit new_user_password_path

    fill_in "Email", :with => "test@example.com"
    click_on "Send me reset password instructions"

    expect(page).to have_text("You will receive an email with instructions about how to reset your password in a few minutes")
  end

  scenario "if the user exists" do
    visit new_user_password_path

    fill_in "Email", :with => "non_user_email@example.com"
    click_button "Send me reset password instructions"

    expect(page).to have_text("Email not found")
  end
end
