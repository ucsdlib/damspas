require 'spec_helper'

# Helper class to store the path of the conference name
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS Conference Name path
	# Used for editing specified conference name
	@path = nil
end


feature 'Visitor wants to create/edit a MADS Conference Name' do 

	scenario 'is on new MADS Conference Name page' do
		sign_in_developer

		visit mads_conference_name_path('new')

		# Create new conference name
		fill_in "ExternalAuthority", :with => "http://johndoe.com"
		fill_in "Name", :with => "ComicCon, 2013"
		fill_in "NameElement", :with => "ComicCon"
		fill_in "DateNameElement", :with => "2013"
		page.select("Test Scheme", match: :first)
		click_on "Submit"
		Path.path = current_path

		expect(page).to have_selector('strong', :text => "ComicCon, 2013")
		expect(page).to have_selector('li', :text => "2013")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://johndoe.com")


	end

	scenario 'is on Edit Conference Name page' do
		sign_in_developer
		visit Path.path

		click_on "Edit"
		fill_in "Name", :with => "Jane Does1, 1950"
		fill_in "ExternalAuthority", :with => "http://conference.com"
		page.select("Test Scheme 2", match: :first)
		fill_in "NameElement", :with => "Jane Does1"
		fill_in "DateNameElement", :with => "1950"
		click_on "Save changes"

		expect(page).to have_selector('strong', :text => "Jane Does1, 1950")
		expect(page).to have_selector('li', :text => "Jane Does1")
		expect(page).to have_selector('li', :text => "1950")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://conference.com")

	end

end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit Conference Name page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "Cancel"
		fill_in "ExternalAuthority", :with => "http://cancel.com"
		page.select("Test Scheme 2", match: :first)
		fill_in "NameElement", :with => "Can Cel"
		fill_in "DateNameElement", :with => "1999"
		click_on "Cancel"
		expect(page).to_not have_content("Can Cel")
		expect(page).to have_content("Jane Does")
	end

end

feature 'Visitor wants to use Hydra View' do
	
	scenario 'is on Conference Name view page' do
		sign_in_developer
		visit Path.path
		click_on "Hydra View"
		expect(page).to have_selector('h1', :text => "Jane Does")
		expect(page).to have_selector('dd', :text => "Jane Does1")
		expect(page).to have_selector('dd', :text => "Does2")
		expect(page).to have_selector('dd', :text => "Jane1")
		expect(page).to have_selector('dd', :text => "1950")
		expect(page).to have_selector('dd', :text => "Last")
		expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('dd', :text => "http://conference.com")
		click_on "Edit"
	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
