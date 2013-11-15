require 'spec_helper'

# Helper class to store the path of the corporate name
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS Corporate Name path
	# Used for editing specified corporate name
	@path = nil
end


feature 'Visitor wants to create/edit a MADS Corporate Name' do 

	scenario 'is on new MADS Corporate Name page' do
		sign_in_developer
		visit "mads_corporate_names"
		expect(page).to have_selector('a', :text => "Create Corporate Name")
		
		visit mads_corporate_name_path('new')

		# Create new corporate name
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

	scenario 'is on Edit Corporate Name page' do
		sign_in_developer
		visit Path.path
		click_on "Edit"
		#fill_in "Name", :with => "Newer Name"
		fill_in "ExternalAuthority", :with => "http://corporatename.com"
		page.select("Test Scheme", match: :first)
		fill_in "Other Name", :with => "New Corporate Name"
		fill_in "Dates", :with => "1990"
		click_on "Save changes"

		###expect(page).to have_selector('strong', :text => "New Corporate Name, 1990")
		expect(page).to have_selector('li', :text => "New Corporate Name")
		expect(page).to have_selector('li', :text => "1990")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
		expect(page).to have_selector('a', :text => "http://corporatename.com")

	end
	
end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit Corporate Name page' do
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
		expect(page).to have_content("New Corporate Name")
	end

end

feature 'Visitor wants to use Hydra View' do
	
	scenario 'is on Corporate Name view page' do
		sign_in_developer
		visit Path.path
		click_on "Hydra View"
		#expect(page).to have_selector('h1', :text => "New Corporate Name, 1920")
		expect(page).to have_selector('dd', :text => "New Corporate Name")
		expect(page).to have_selector('dd', :text => "1990")
		expect(page).to have_selector('dd', :text => "http://corporatename.com")
		click_on "Edit"
	end

end


def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
