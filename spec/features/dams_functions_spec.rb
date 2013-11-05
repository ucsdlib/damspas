require 'spec_helper'

# Class to store the path of the Function
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store DAMS Function path
	# Used for editing specified Function
	@path = nil
end

feature 'Visitor wants to create/edit a DAMS Function' do
  let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
  let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }
  let!(:scheme3) { MadsScheme.create!(name: 'Test Scheme') }

  after do
    scheme1.destroy
    scheme2.destroy
    scheme3.destroy
  end
  
	scenario 'is on new DAMS Function page' do
		sign_in_developer
		visit "dams_functions"
		expect(page).to have_selector('a', :text => "Create Function")
		
		visit dams_function_path('new')
		# Create new Function
		fill_in "Name", :with => "Test Function"
		fill_in "ExternalAuthority", :with => "http://functions.com"
		fill_in "Element Value", :with => "Test Function"
		page.select('Library of Congress Subject Headings', match: :first) 
		click_on "Submit"

		# Save path of Function for other test(s)
		Path.path = current_path
		expect(page).to have_selector('a', :text => "http://functions.com")
		expect(page).to have_selector('li', :text => "Test Function")
		expect(page).to have_selector('li', :text => "Library of Congress Subject Headings")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "Edit Function after Create"
		fill_in "ExternalAuthority", :with => "http://editfunction.com"
		fill_in "Element Value", :with => "Job"
		page.select('Library of Congress Name Authority File', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		#expect(page).to have_selector('strong', :text => "Edit Function after Create")
		expect(page).to have_selector('a', :text => "http://editfunction.com")
		expect(page).to have_selector('li', :text => "Job")
		expect(page).to have_selector('li', :text => "Library of Congress Name Authority File")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		# Check Hydra View
		click_on "Hydra View"
		expect(page).to have_selector('dd', :text => "http://editfunction.com")
		expect(page).to have_selector('dd', :text => "Job")
		expect(page).to have_content('Edit')

	end

	scenario 'is on the Function page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Name", :with => "Final Function"
		fill_in "ExternalAuthority", :with => "http://finalfunction.com"
		fill_in "Element Value", :with => "Reminder"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('a', :text => "http://finalfunction.com")
		expect(page).to have_selector('li', :text => "Reminder")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
	let!(:scheme) { MadsScheme.create!(name: 'Test Scheme 2') }

	after do
		scheme.destroy
	end

	scenario 'is on Edit Function page' do
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
