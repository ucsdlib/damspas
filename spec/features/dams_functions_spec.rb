require 'spec_helper'

# Class to store the path of the function
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS Function path
	# Used for editing specified function
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS Function' do

	scenario 'is on new DAMS Function page' do
		sign_in_developer

		visit dams_function_path('new')
		# Create new function
		fill_in "Name", :with => "Test Function"
		fill_in "ExternalAuthority", :with => "http://function.com"
		fill_in "FunctionElement", :with => "Nothing"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of function for other test(s)
		Path.path = current_path
		expect(page).to have_selector('strong', :text => "Test Function")
		expect(page).to have_selector('a', :text => "http://function.com")
		expect(page).to have_selector('li', :text => "Nothing")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edit Function after Create"
		fill_in "ExternalAuthority", :with => "http://editfunctioncreate.edu"
		fill_in "FunctionElement", :with => "Something"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('strong', :text => "Edit Function after Create")
		expect(page).to have_selector('a', :text => "http://editfunctioncreate.edu")
		expect(page).to have_selector('li', :text => "Something")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

	scenario 'is on the Function page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Final Function"
		fill_in "ExternalAuthority", :with => "http://finalfunction.edu"
		fill_in "FunctionElement", :with => "Everything"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('strong', :text => "Final Function")
		expect(page).to have_selector('a', :text => "http://finalfunction.edu")
		expect(page).to have_selector('li', :text => "Everything")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	
	scenario 'is on Edit Function page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "FunctionElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Final Function")
	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
