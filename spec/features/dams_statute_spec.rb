require 'spec_helper'

# Class to store the path of the Statute
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS Statute path
	# Used for editing specified Statute
	@path = nil
end

feature 'Visit wants to look at statute options' do

  scenario 'retrieve a statute record' do
    sign_in_developer
    DamsStatute.create! pid: "fx45454545", citation: "FOO", jurisdiction: "us", note: "foo", restrictionBeginDate: "2012-12-31", restrictionEndDate: "2062-12-31", restrictionType: "display"

    # visit list page and make sure object is there
    visit dams_statutes_path
    expect(page).to have_content("FOO")

  end

end

feature 'Visitor wants to create/edit a DAMS Statute' do
	scenario 'is on new DAMS Statute page' do
		sign_in_developer
		visit "dams_statutes"
		expect(page).to have_selector('a', :text => "Create Statute")
		
		visit dams_statute_path('new')
		# Create new Statute
		fill_in "Note", :with => "Test Note"
		fill_in "Citation", :with => "citation test"
		fill_in "Permission Type", :with => "display"
		fill_in "Permission Begin Date", :with => "2011"
		fill_in "Permission End Date", :with => "2012"
		fill_in "Restriction Type", :with => "restrict"
		fill_in "Restriction Begin Date", :with => "2013"
		fill_in "Restriction End Date", :with => "2014"
		
		click_on "Save"

		# Save path of Statute for other test(s)
		Path.path = current_path
		expect(page).to have_selector('li', :text => "citation test")
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
