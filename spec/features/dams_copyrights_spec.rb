require 'spec_helper'

# Class to store the path of the Copyright
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS Copyright path
	# Used for editing specified Copyright
	@path = nil
end

feature 'Visit wants to look at copyright options' do

  scenario 'retrieve a copyright record' do
    sign_in_developer
    DamsCopyright.create! pid: "fx05050505", status: "Under copyright", jurisdiction: "us", purposeNote: "This work is available from the UC San Diego Libraries. This digital copy of the work is intended to support research, teaching, and private study.", note: "This work is protected by the U.S. Copyright Law (Title 17, U.S.C.).  Use of this work beyond that allowed by \"fair use\" requires written permission of the copyright holder(s). Responsibility for obtaining permissions and any use and distribution of this work rests exclusively with the user and not the UC San Diego Libraries.", beginDate: "1993-12-31"

    # visit list page and make sure object is there
    visit dams_copyrights_path
    expect(page).to have_content("Under copyright")

  end

end

feature 'Visitor wants to create/edit a DAMS Copyright' do
	scenario 'is on new DAMS Copyright page' do
		sign_in_developer
		visit "dams_copyrights"
		expect(page).to have_selector('a', :text => "Create Copyright")
		
		visit dams_copyright_path('new')
		# Create new Copyright
		fill_in "Status", :with => "Test Status"
		fill_in "Jurisdiction", :with => "Test Jurisdiction"
		fill_in "Note", :with => "Test Note"
		fill_in "Purpose Note", :with => "Test Purpose Note"
		fill_in "Begin Date", :with => "2011"
		fill_in "End Date", :with => "2012"
		fill_in "Date", :with => "2013"
		click_on "Save"

		# Save path of Copyright for other test(s)
		Path.path = current_path
		expect(page).to have_selector('li', :text => "Test Jurisdiction")
		expect(page).to have_selector('li', :text => "Test Note")
		expect(page).to have_selector('li', :text => "Test Purpose Note")
		expect(page).to have_selector('li', :text => "2011")
		expect(page).to have_selector('li', :text => "2012")
		expect(page).to have_selector('li', :text => "2013")
		
		expect(page).to have_selector('a', :text => "Edit")

	end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
