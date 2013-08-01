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

		visit mads_personal_name_path('new')

		# Create new personal name
		fill_in "Name", :with => "John Doe"
		fill_in "ExternalAuthority", :with => "http://johndoe.com"
		fill_in "Full Name", :with => "John James Doe"
		fill_in "FamilyNameElement", :with => "Doe1"
		fill_in "GivenNameElement", :with => "Johnson"
		fill_in "DateNameElement", :with => "1900"
		fill_in "TermOfAddressElement", :with => "First"
		page.select("Test Scheme", match: :first)
		click_on "Submit"
		Path.path = current_path

		expect(page).to have_selector('strong', :text => "John Doe")
		expect(page).to have_selector('li', :text => "John James Doe")
		expect(page).to have_selector('li', :text => "Doe1")
		expect(page).to have_selector('li', :text => "Johnson")
		expect(page).to have_selector('li', :text => "1900")
		expect(page).to have_selector('li', :text => "First")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://johndoe.com")

		click_on "Edit"
		fill_in "Authoritative Label", :with => "Jane Does"
		fill_in "ExternalAuthority", :with => "http://janedoes.com"
		page.select("Test Scheme 2", match: :first)
		fill_in "Full Name", :with => "Jane Does1"
		fill_in "Family Name", :with => "Does2"
		fill_in "Given Name", :with => "Jane1"
		fill_in "Date", :with => "1950"
		fill_in "Term Of Address", :with => "Last"
		click_on "Save changes"

		expect(page).to have_selector('strong', :text => "Jane Does")
		expect(page).to have_selector('li', :text => "Jane Does1")
		expect(page).to have_selector('li', :text => "Does2")
		expect(page).to have_selector('li', :text => "Jane1")
		expect(page).to have_selector('li', :text => "1950")
		expect(page).to have_selector('li', :text => "Last")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://janedoes.com")

	end

	scenario 'is on Edit Personal Name page' do
		sign_in_developer
		visit Path.path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "New Name"
		fill_in "ExternalAuthority", :with => "http://personal.com"
		page.select("Test Scheme", match: :first)
		fill_in "Full Name", :with => "New Name1"
		fill_in "Family Name", :with => "Name2"
		fill_in "Given Name", :with => "New1"
		fill_in "Dates", :with => "1980"
		fill_in "Terms of Address", :with => "Median"
		click_on "Save changes"

		expect(page).to have_selector('strong', :text => "New Name")
		expect(page).to have_selector('li', :text => "New Name1")
		expect(page).to have_selector('li', :text => "Name2")
		expect(page).to have_selector('li', :text => "New1")
		expect(page).to have_selector('li', :text => "1980")
		expect(page).to have_selector('li', :text => "Median")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://personal.com")

	end

end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit Personal Name page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Cancel"
		fill_in "ExternalAuthority", :with => "http://cancel.com"
		page.select("Test Scheme 2", match: :first)
		fill_in "Full Name", :with => "Can Cel"
		fill_in "Family Name", :with => "Cel"
		fill_in "Given Name", :with => "Can"
		fill_in "Dates", :with => "1999"
		fill_in "Terms of Address", :with => "Not here"
		click_on "Cancel"
		expect(page).to_not have_content("Can Cel")
		expect(page).to have_content("New Name")
	end

end

feature 'Visitor wants to use Hydra View' do
	
	scenario 'is on Personal Name view page' do
		sign_in_developer
		visit Path.path
		click_on "Hydra View"
		expect(page).to have_selector('h1', :text => "New Name")
		expect(page).to have_selector('dd', :text => "New Name1")
		expect(page).to have_selector('dd', :text => "Name2")
		expect(page).to have_selector('dd', :text => "New1")
		expect(page).to have_selector('dd', :text => "1980")
		expect(page).to have_selector('dd', :text => "Median")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('dd', :text => "http://personal.com")
		click_on "Edit"
	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
