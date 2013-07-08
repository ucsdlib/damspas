require 'spec_helper'

# Class to store the path of the genre form
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS GenreForm path
	# Used for editing specified genre form
	@path = nil
end

feature 'Visitor wants to create/edit a MADS GenreForm' do 
	
	scenario 'is on new MADS GenreForm page' do
		sign_in_developer

		visit mads_genre_form_path('new')
		# Create new genre form
		fill_in "Name", :with => "Tester1"
		fill_in "ExternalAuthority", :with => "http://testform.com"
		fill_in "GenreFormElement", :with => "Science"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of occupation for other test(s)
		Path.path = current_path
		expect(page).to have_selector('strong', :text => "Tester1")
		expect(page).to have_selector('a', :text => "http://testform.com")
		expect(page).to have_selector('li', :text => "Science")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "New GenreForm1"
		fill_in "ExternalAuthority", :with => "http://newform.edu"
		fill_in "GenreFormElement", :with => "History"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('strong', :text => "New GenreForm1")
		expect(page).to have_selector('a', :text => "http://newform.edu")
		expect(page).to have_selector('li', :text => "History")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

	scenario 'is on the GenreForm page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "GenreForm2"
		fill_in "ExternalAuthority", :with => "http://editedform.edu"
		fill_in "GenreFormElement", :with => "Math"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"

		expect(page).to have_selector('strong', :text => "GenreForm2")
		expect(page).to have_selector('a', :text => "http://editedform.edu")
		expect(page).to have_selector('li', :text => "Math")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit Occupation page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "GenreFormElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("GenreForm2")
		expect(page).to have_content("GenreFormElement")

	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
