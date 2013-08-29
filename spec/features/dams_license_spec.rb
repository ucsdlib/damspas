require 'spec_helper'

feature 'Visit wants to look at license options' do

  scenario 'retrieve a license record' do
    sign_in_developer
    DamsLicense.create! pid: "bb22222222", note: "FOO", uri: "http://foo.com", permissionBeginDate: "2012-12-31", permissionEndDate: "2062-12-31", permissionType: "display"

    # visit list page and make sure object is there
    visit dams_licenses_path
    expect(page).to have_content("FOO")

  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
