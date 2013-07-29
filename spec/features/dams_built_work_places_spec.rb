require 'spec_helper'

# Class to store the path of the BuiltWorkPlace
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS BuiltWorkPlace path
	# Used for editing specified BuiltWorkPlace
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS BuiltWorkPlace' do

	scenario 'is on new DAMS BuiltWorkPlace page' do
		sign_in_developer

		visit dams_built_work_place_path('new')
		# Create new BuiltWorkPlace
		fill_in "Name", :with => "Test BuiltWorkPlace"
		fill_in "ExternalAuthority", :with => "http://builtworkplace.com"
		fill_in "BuiltWorkPlaceElement", :with => "Geisel"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of BuiltWorkPlace for other test(s)
		Path.path = current_path
		expect(page).to have_selector('strong', :text => "Test BuiltWorkPlace")
		expect(page).to have_selector('a', :text => "http://builtworkplace.com")
		expect(page).to have_selector('li', :text => "Geisel")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edit BuiltWorkPlace after Create"
		fill_in "ExternalAuthority", :with => "http://editbuiltworkplacecreate.com"
		fill_in "BuiltWorkPlaceElement", :with => "Office"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('strong', :text => "Edit BuiltWorkPlace after Create")
		expect(page).to have_selector('a', :text => "http://editbuiltworkplacecreate.com")
		expect(page).to have_selector('li', :text => "Office")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		# Check Hydra View
		click_on "Hydra View"
		expect(page).to have_selector('h1', :text => "Edit BuiltWorkPlace after Create")
		expect(page).to have_selector('dd', :text => "http://editbuiltworkplacecreate.com")
		expect(page).to have_selector('dd', :text => "Office")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_content('Edit')

		click_on "Solr View"
	end

	scenario 'is on the BuiltWorkPlace page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Final BuiltWorkPlace"
		fill_in "ExternalAuthority", :with => "http://finalworkplace.com"
		fill_in "BuiltWorkPlaceElement", :with => "Library"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('strong', :text => "Final BuiltWorkPlace")
		expect(page).to have_selector('a', :text => "http://finalworkplace.com")
		expect(page).to have_selector('li', :text => "Library")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit BuiltWorkPlace page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "BuiltWorkPlaceElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Final BuiltWorkPlace")
	end

end



def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
