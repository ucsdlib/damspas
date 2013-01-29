require 'spec_helper'

feature 'Visit wants to look at statute options' do

  scenario 'retrieve a statute record' do
    sign_in_developer
    DamsStatute.create! pid: "bb45454545", citation: "FOO", jurisdiction: "us", note: "foo", restrictionBeginDate: "2012-12-31", restrictionEndDate: "2062-12-31", restrictionType: "display"

    # visit list page and make sure object is there
    visit dams_statutes_path
    expect(page).to have_content("FOO")

  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
