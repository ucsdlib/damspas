require 'spec_helper'
# Class to store the path of the License
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS License path
	# Used for editing specified License
	@path = nil
end

feature 'Visit wants to look at license options' do

  scenario 'retrieve a license record' do
    sign_in_developer
    DamsLicense.create! pid: "fx22222222", note: "FOO", uri: "http://foo.com", permissionBeginDate: "2012-12-31", permissionEndDate: "2062-12-31", permissionType: "display"

    # visit list page and make sure object is there
    visit dams_licenses_path
    expect(page).to have_content("FOO")

  end

end

feature 'Visitor wants to create/edit a DAMS License' do
	scenario 'is on new DAMS License page' do
		sign_in_developer
		visit "dams_licenses"
		expect(page).to have_selector('a', :text => "Create License")
		
		visit dams_license_path('new')
		# Create new License
		fill_in "Note", :with => "Test Note"
		fill_in "URI", :with => "http://b.com"
		fill_in "Permission Type", :with => "display"
		fill_in "Permission Begin Date", :with => "2011"
		fill_in "Permission End Date", :with => "2012"
		fill_in "Restriction Type", :with => "restrict"
		fill_in "Restriction Begin Date", :with => "2013"
		fill_in "Restriction End Date", :with => "2014"
		
		click_on "Save"

		# Save path of License for other test(s)
		Path.path = current_path
		expect(page).to have_selector('li', :text => "http://b.com")
		expect(page).to have_selector('li', :text => "display")
		expect(page).to have_selector('li', :text => "2011")
		expect(page).to have_selector('li', :text => "2012")
		expect(page).to have_selector('li', :text => "restrict")
		expect(page).to have_selector('li', :text => "2013")
		expect(page).to have_selector('li', :text => "2014")
		
		expect(page).to have_selector('a', :text => "Edit")
	end
end
def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
