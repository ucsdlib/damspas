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
    let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
    let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }

    after do
    	scheme1.destroy
    	scheme2.destroy
    end
    
	scenario 'is on new MADS GenreForm page' do
		sign_in_developer
	    visit "mads_genre_forms"
		expect(page).to have_selector('a', :text => "Create Genre Form")
		
		visit mads_genre_form_path('new')
		# Create new genre form
		fill_in "Name", :with => "TestLabel"
		fill_in "ExternalAuthority", :with => "http://testform.com"
		fill_in "Element Value", :with => "TestElement"
		page.select('Library of Congress Subject Headings', match: :first) 
		click_on "Submit"

		# Save path of GenreForm for other test(s)
		Path.path = current_path
		expect(Path.path).to eq(current_path)
		#expect(page).to have_selector('strong', :text => "Tester1")
		expect(page).to have_selector('a', :text => "http://testform.com")
		expect(page).to have_selector('li', :text => "TestElement")
		expect(page).to have_selector('li', :text => "Library of Congress Subject Headings")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "New GenreForm1"
		fill_in "ExternalAuthority", :with => "http://newform.edu"
		fill_in "Element Value", :with => "Test Element2"
		page.select('Library of Congress Name Authority File', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		#expect(page).to have_selector('strong', :text => "New GenreForm1")
		expect(page).to have_selector('a', :text => "http://newform.edu")
		expect(page).to have_selector('li', :text => "Test Element2")
		expect(page).to have_selector('li', :text => "Library of Congress Name Authority File")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

	scenario 'is on the GenreForm page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Name", :with => "GenreForm2"
		fill_in "ExternalAuthority", :with => "http://editedform.edu"
		fill_in "Element Value", :with => "Test Element"
		page.select('Library of Congress Name Authority File', match: :first) 
		click_on "Save changes"

		expect(page).to have_selector('a', :text => "http://editedform.edu")
		expect(page).to have_selector('li', :text => "Test Element")
		expect(page).to have_selector('li', :text => "Library of Congress Name Authority File")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
    let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
    let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }

    after do
    	scheme1.destroy
    	scheme2.destroy
    end
    
	scenario 'is on Edit GenreForm page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "Element Value", :with => "Should not show"
		page.select('Library of Congress Name Authority File', match: :first)
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Test Element")
	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
