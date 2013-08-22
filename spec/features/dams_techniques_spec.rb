require 'spec_helper'

# Class to store the path of the technique
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS Technique path
	# Used for editing specified technique
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS Technique' do

	scenario 'is on new DAMS Technique page' do
		sign_in_developer

		visit dams_technique_path('new')
		# Create new technique
		fill_in "Name", :with => "Test Technique"
		fill_in "ExternalAuthority", :with => "http://technique.com"
		fill_in "TechniqueElement", :with => "None"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of technique for other test(s)
		Path.path = current_path
		expect(page).to have_selector('strong', :text => "Test Technique")
		expect(page).to have_selector('a', :text => "http://technique.com")
		expect(page).to have_selector('li', :text => "None")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edit Technique after Create"
		fill_in "ExternalAuthority", :with => "http://edittechniquecreate.edu"
		fill_in "TechniqueElement", :with => "Different"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('strong', :text => "Edit Technique after Create")
		expect(page).to have_selector('a', :text => "http://edittechniquecreate.edu")
		expect(page).to have_selector('li', :text => "Different")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		# Check Hydra View
		click_on "Hydra View"
		expect(page).to have_selector('h1', :text => "Edit Technique after Create")
		expect(page).to have_selector('dd', :text => "http://edittechniquecreate.edu")
		expect(page).to have_selector('dd', :text => "Different")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")

		click_on "Solr View"
	end

	scenario 'is on the Technique page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Final Technique"
		fill_in "ExternalAuthority", :with => "http://finaltechnique.edu"
		fill_in "TechniqueElement", :with => "Thorough"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('strong', :text => "Final Technique")
		expect(page).to have_selector('a', :text => "http://finaltechnique.edu")
		expect(page).to have_selector('li', :text => "Thorough")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit Technique page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "TechniqueElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Final Technique")
	end

end



def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
