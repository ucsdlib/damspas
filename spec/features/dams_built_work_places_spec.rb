require 'spec_helper'

# Class to store the path of the built work place
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS built work place path
	# Used for editing specified built work place
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS built work place' do
  let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
  let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }

  after do
    scheme1.destroy
    scheme2.destroy
  end
  
	scenario 'is on new DAMS built work place page' do
		sign_in_developer
		visit "dams_built_work_places"
		
		
		visit dams_built_work_place_path('new')
		# Create new built work place
		fill_in "Name", :with => "Test built work place"
		fill_in "ExternalAuthority", :with => "http://builtWorkPlaces.com"
		fill_in "Element Value", :with => "Test built work place"
		page.select('Library of Congress Subject Headings', match: :first) 
		click_on "Submit"

		# Save path of built work place for other test(s)
		Path.path = current_path
		expect(page).to have_selector('a', :text => "http://builtWorkPlaces.com")
		expect(page).to have_selector('li', :text => "Library of Congress Subject Headings")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "Edit built work place after Create"
		fill_in "ExternalAuthority", :with => "http://builtWorkPlaceedit.com"
		fill_in "Element Value", :with => "Orange"
		page.select('Library of Congress Name Authority File', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		
		expect(page).to have_selector('a', :text => "http://builtWorkPlaceedit.com")
		expect(page).to have_selector('li', :text => "Library of Congress Name Authority File")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		# Check Hydra View
		click_on "Hydra View"
		expect(page).to have_selector('dd', :text => "http://builtWorkPlaceedit.com")
		expect(page).to have_selector('dd', :text => "Orange")
		expect(page).to have_content('Edit')

	end

	scenario 'is on the built work place page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Name", :with => "Final built work place"
		fill_in "ExternalAuthority", :with => "http://finalbuiltWorkPlace.com"
		fill_in "Element Value", :with => "Library"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('a', :text => "http://finalbuiltWorkPlace.com")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit built work place page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "Element Value", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
	end

end



def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
