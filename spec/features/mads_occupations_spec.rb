require 'spec_helper'

# Class to store the path of the occupation
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS Occupation path
	# Used for editing specified occupation
	@path = nil
end

feature 'Visitor wants to create/edit a MADS Occupation' do 
  let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
  let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }

  after do
    scheme1.destroy
    scheme2.destroy
  end	
	scenario 'is on new MADS Occupation page' do
		sign_in_developer
		visit "mads_topics"
		expect(page).to have_selector('a', :text => "Create Topic")
		
		visit "mads_occupations/new"
		# Create new occupation
		fill_in "Name", :with => "Test Occupation"
		fill_in "ExternalAuthority", :with => "http://occupation.com"
		fill_in "Element Value", :with => "TestElement"
		page.select('Library of Congress Subject Headings', match: :first) 
		#select('Test Scheme', from: 'Scheme') 
		click_on "Submit"
		
		# Save path of occupation for other test(s)
		Path.path = current_path
		expect(page).to have_selector('a', :text => "http://occupation.com")
		expect(page).to have_selector('li', :text => "TestElement")
		expect(page).to have_selector('li', :text => "Library of Congress Subject Headings")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "Edit Occupation after Create"
		fill_in "ExternalAuthority", :with => "http://editoccaftercreate.edu"
		fill_in "Element Value", :with => "Test Element2"
		page.select('Library of Congress Name Authority File', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('a', :text => "http://editoccaftercreate.edu")
		expect(page).to have_selector('li', :text => "Test Element2")
		expect(page).to have_selector('li', :text => "Library of Congress Name Authority File")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

	scenario 'is on the Occupation page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Name", :with => "Edited Occupation"
		fill_in "ExternalAuthority", :with => "http://editedocc.edu"
		fill_in "Element Value", :with => "Test Element"
		page.select('Library of Congress Subject Headings', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('a', :text => "http://editedocc.edu")
		expect(page).to have_selector('li', :text => "Test Element")
		expect(page).to have_selector('li', :text => "Library of Congress Subject Headings")
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
	scenario 'is on Edit Occupation page' do
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
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
