require 'spec_helper'
# Class to store the path of the OtherRight
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS OtherRight path
	# Used for editing specified OtherRight
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS OtherRight' do
  let!(:role) { MadsAuthority.create!(name: 'Authority Role Test') }
  let!(:name) { MadsName.create!(name: 'Test Name') }

  after do
    role.destroy
    name.destroy
  end
	scenario 'is on new DAMS OtherRight page' do
		sign_in_developer
		visit "dams_other_rights"
		expect(page).to have_selector('a', :text => "Create OtherRights")
		
		visit dams_other_right_path('new')
		# Create new OtherRight
		fill_in "Note", :with => "Test Note"
		fill_in "URI", :with => "http://b.com"
		fill_in "Permission Type", :with => "display"
		fill_in "Permission Begin Date", :with => "2011"
		fill_in "Permission End Date", :with => "2012"
		fill_in "Restriction Type", :with => "restrict"
		fill_in "Restriction Begin Date", :with => "2013"
		fill_in "Restriction End Date", :with => "2014"
		page.select('Authority Role Test', match: :first) 
		page.select('Test Name', match: :first) 
		click_on "Save"	
	end
end
def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
