require 'spec_helper'

feature 'Visit wants to look at copyright options' do

  scenario 'retrieve a copyright record' do
    sign_in_developer
    DamsCopyright.create! pid: "bb45454545", status: "under copyright--1st party", jurisdiction: "us", purposeNote: "foo", note: "bar", beginDate: "2012-12-31"

    # visit list page and make sure object is there
    visit dams_copyrights_path
    expect(page).to have_content("under copyright--1st party")

  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
