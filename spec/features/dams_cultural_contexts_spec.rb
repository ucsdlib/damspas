require 'spec_helper'

# Class to store the path of the cultural context
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS cultural context path
	# Used for editing specified cultural context
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS cultural context' do
  let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
  let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }

  after do
    scheme1.destroy
    scheme2.destroy
  end
  
	scenario 'is on new DAMS cultural context page' do
		sign_in_developer
		visit "dams_cultural_contexts"
		#expect(page).to have_selector('a', :text => "Create cultural context")
		
		visit dams_cultural_context_path('new')
		# Create new cultural context
		fill_in "Name", :with => "Test cultural context"
		fill_in "ExternalAuthority", :with => "http://culturalcontexts.com"
		fill_in "Element Value", :with => "Test cultural context"
		page.select('Library of Congress Subject Headings', match: :first) 
		click_on "Submit"

		# Save path of cultural context for other test(s)
		Path.path = current_path
		expect(page).to have_selector('a', :text => "http://culturalcontexts.com")
		#expect(page).to have_selector('li', :text => "Test cultural context")
		expect(page).to have_selector('li', :text => "Library of Congress Subject Headings")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "Edit cultural context after Create"
		fill_in "ExternalAuthority", :with => "http://culturalcontextedit.com"
		fill_in "Element Value", :with => "Orange"
		page.select('Library of Congress Name Authority File', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		#expect(page).to have_selector('strong', :text => "Edit cultural context after Create")
		expect(page).to have_selector('a', :text => "http://culturalcontextedit.com")
		#expect(page).to have_selector('li', :text => "Orange")
		expect(page).to have_selector('li', :text => "Library of Congress Name Authority File")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		# Check Hydra View
		click_on "Hydra View"
		expect(page).to have_selector('dd', :text => "http://culturalcontextedit.com")
		expect(page).to have_selector('dd', :text => "Orange")
		expect(page).to have_content('Edit')

	end

	scenario 'is on the cultural context page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Name", :with => "Final cultural context"
		fill_in "ExternalAuthority", :with => "http://finalculturalcontext.com"
		fill_in "Element Value", :with => "Library"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('a', :text => "http://finalculturalcontext.com")
		#expect(page).to have_selector('li', :text => "Library")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit cultural context page' do
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
