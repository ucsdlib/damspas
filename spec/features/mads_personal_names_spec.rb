require 'spec_helper'

# Helper class to store the path of the personal name
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS Personal Name path
	# Used for editing specified personal name
	@path = nil
end


feature 'Visitor wants to create/edit a MADS Personal Name' do 

	scenario 'is on new MADS Personal Name page' do
		sign_in_developer
		visit "mads_personal_names"
		expect(page).to have_selector('a', :text => "Create Personal Name")
		
		visit mads_personal_name_path('new')

		# Create new personal name
		fill_in "Other Name", :with => "FooCorp"
		fill_in "Dates", :with => "1920"
		fill_in "ExternalAuthority", :with => "http://misterdoe.com"
		page.select("Test Scheme", match: :first)
		click_on "Save"
		Path.path = current_path

		###expect(page).to have_selector('strong', :text => "FooCorp, 1920")
		expect(page).to have_selector('li', :text => "FooCorp")
		expect(page).to have_selector('li', :text => "1920")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://misterdoe.com")

		click_on "Edit"
		fill_in "Name", :with => "Last1, 1970"
		fill_in "Other Name", :with => "Last1"
		fill_in "Dates", :with => "1970"
		fill_in "ExternalAuthority", :with => "http://missdoes.com"
		page.select("Test Scheme 2", match: :first)
		click_on "Save changes"

		###expect(page).to have_selector('strong', :text => "Last1, 1970")
		expect(page).to have_selector('li', :text => "Last1")
		expect(page).to have_selector('li', :text => "1970")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://missdoes.com")

	end

	scenario 'is on Edit Personal Name page' do
		sign_in_developer
		visit Path.path
		click_on "Edit"
		#fill_in "Name", :with => "Newer Name"
		fill_in "ExternalAuthority", :with => "http://personalname.com"
		page.select("Test Scheme", match: :first)
		fill_in "Other Name", :with => "New Personal Name"
		fill_in "Dates", :with => "1990"
		click_on "Save changes"

		###expect(page).to have_selector('strong', :text => "New Personal Name, 1990")
		expect(page).to have_selector('li', :text => "New Personal Name")
		expect(page).to have_selector('li', :text => "1990")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://personalname.com")

	end
	
end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit Personal Name page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		#fill_in "Name", :with => "Cancel"
		fill_in "ExternalAuthority", :with => "http://cancel.com"
		page.select("Test Scheme 2", match: :first)
		fill_in "Other Name", :with => "Can Cel"
		fill_in "Dates", :with => "1999"
		click_on "Cancel"
		expect(page).to_not have_content("Can Cel")
		expect(page).to have_content("New Personal Name")
	end

end

feature 'Visitor wants to use Hydra View' do
	
	scenario 'is on Personal Name view page' do
		sign_in_developer
		visit Path.path
		click_on "Hydra View"
		#expect(page).to have_selector('h1', :text => "New Personal Name, 1920")
		expect(page).to have_selector('dd', :text => "New Personal Name")
		expect(page).to have_selector('dd', :text => "1990")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('dd', :text => "http://personalname.com")
		click_on "Edit"
	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
