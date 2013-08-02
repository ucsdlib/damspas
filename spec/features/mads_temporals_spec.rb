require 'spec_helper'

# Class to store the path of the temporal
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS Temporal path
	# Used for editing specified temporal
	@path = nil
end

feature 'Visitor wants to create/edit a MADS Temporal' do 

	scenario 'is on new invalid MADS Temporal page' do
		sign_in_developer

		visit "mads_temporals/new"
		# Create new temporal
		fill_in "Name", :with => ""
		fill_in "ExternalAuthority", :with => "http://Temporal.com"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"
		expect(page).to have_content("can't be blank")
	end
	
	scenario 'is on new MADS Temporal page' do
		sign_in_developer

		visit "mads_temporals/new"
		# Create new temporal
		fill_in "Name", :with => "Test Temporal"
		fill_in "ExternalAuthority", :with => "http://Temporal.com"
		fill_in "TemporalElement", :with => "Hour"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of temporal for other test(s)
		Path.path = current_path
		expect(page).to have_selector('strong', :text => "Test Temporal")
		expect(page).to have_selector('a', :text => "http://Temporal.com")
		expect(page).to have_selector('li', :text => "Hour")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edit Temporal after Create"
		fill_in "ExternalAuthority", :with => "http://edittempaftercreate.edu"
		fill_in "TemporalElement", :with => "Days"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('strong', :text => "Edit Temporal after Create")
		expect(page).to have_selector('a', :text => "http://edittempaftercreate.edu")
		expect(page).to have_selector('li', :text => "Days")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

	scenario 'is on the Temporal page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edited Temporal"
		fill_in "ExternalAuthority", :with => "http://editedtime.edu"
		fill_in "TemporalElement", :with => "Year"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('strong', :text => "Edited Temporal")
		expect(page).to have_selector('a', :text => "http://editedtime.edu")
		expect(page).to have_selector('li', :text => "Year")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end


end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit Temporal page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "TemporalElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Edited Temporal")
	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
