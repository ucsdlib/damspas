require 'spec_helper'

# Class to store the path of the Iconography
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS Iconography path
	# Used for editing specified Iconography
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS Iconography' do

	scenario 'is on new DAMS Iconography page' do
		sign_in_developer

		visit dams_iconography_path('new')
		# Create new Iconography
		fill_in "Name", :with => "Test Iconography"
		fill_in "ExternalAuthority", :with => "http://iconographies.com"
		fill_in "IconographyElement", :with => "Apple"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of Iconography for other test(s)
		Path.path = current_path
		expect(page).to have_selector('strong', :text => "Test Iconography")
		expect(page).to have_selector('a', :text => "http://iconographies.com")
		expect(page).to have_selector('li', :text => "Apple")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edit Iconography after Create"
		fill_in "ExternalAuthority", :with => "http://iconographyedit.com"
		fill_in "IconographyElement", :with => "Orange"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('strong', :text => "Edit Iconography after Create")
		expect(page).to have_selector('a', :text => "http://iconographyedit.com")
		expect(page).to have_selector('li', :text => "Orange")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		# Check Hydra View
		click_on "Hydra View"
		expect(page).to have_selector('h1', :text => "Edit Iconography after Create")
		expect(page).to have_selector('dd', :text => "http://iconographyedit.com")
		expect(page).to have_selector('dd', :text => "Orange")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_content('Edit')

		click_on "Solr View"
	end

	scenario 'is on the Iconography page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Final Iconography"
		fill_in "ExternalAuthority", :with => "http://finaliconography.com"
		fill_in "IconographyElement", :with => "Library"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('strong', :text => "Final Iconography")
		expect(page).to have_selector('a', :text => "http://finaliconography.com")
		expect(page).to have_selector('li', :text => "Library")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit Iconography page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "IconographyElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Final Iconography")
	end

end



def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
