require 'spec_helper'

feature 'Visit wants to look at copyright options' do

  scenario 'retrieve a copyright record' do
    sign_in_developer
    DamsCopyright.create! pid: "bb05050505", status: "under copyright", jurisdiction: "us", purposeNote: "This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study.", note: "This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries.", beginDate: "1993-12-31"

    # visit list page and make sure object is there
    visit dams_copyrights_path
    expect(page).to have_content("under copyright")

  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
