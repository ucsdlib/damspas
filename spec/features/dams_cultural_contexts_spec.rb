require 'spec_helper'

# Class to store the path of the cultural context
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS Cultural Context path
	# Used for editing specified cultural context
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS Cultural Context' do

	scenario 'is on new DAMS Cultural Context page' do
		sign_in_developer

		visit dams_cultural_context_path('new')
		# Create new cultural context
		fill_in "Name", :with => "Test Cultural Context"
		fill_in "ExternalAuthority", :with => "http://culturalcontext.com"
		fill_in "CulturalContextElement", :with => "Baseball"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of cultural context for other test(s)
		Path.path = current_path
		expect(page).to have_selector('strong', :text => "Test Cultural Context")
		expect(page).to have_selector('a', :text => "http://culturalcontext.com")
		expect(page).to have_selector('li', :text => "Baseball")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edit Cultural Context after Create"
		fill_in "ExternalAuthority", :with => "http://editculturalcontextcreate.edu"
		fill_in "CulturalContextElement", :with => "Football"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('strong', :text => "Edit Cultural Context after Create")
		expect(page).to have_selector('a', :text => "http://editculturalcontextcreate.edu")
		expect(page).to have_selector('li', :text => "Football")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		# Check Hydra View
		click_on "Hydra View"
		expect(page).to have_selector('h1', :text => "Edit Cultural Context after Create")
		expect(page).to have_selector('dd', :text => "http://editculturalcontextcreate.edu")
		expect(page).to have_selector('dd', :text => "Football")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")

		click_on "Solr View"
	end

	scenario 'is on the Cultural Context page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Final Cultural Context"
		fill_in "ExternalAuthority", :with => "http://finalculturalcontext.edu"
		fill_in "CulturalContextElement", :with => "Basketball"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('strong', :text => "Final Cultural Context")
		expect(page).to have_selector('a', :text => "http://finalculturalcontext.edu")
		expect(page).to have_selector('li', :text => "Basketball")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit Cultural Context page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "CulturalContextElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Final Cultural Context")
	end

end



def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
