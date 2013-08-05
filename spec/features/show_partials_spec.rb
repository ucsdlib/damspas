require 'spec_helper'

# Class to store the path of the object
class Path
  class << self
    attr_accessor :path
  end
  # Variable to be used to store DAMS Object path
  # Used for editing specified object
  @path = nil
end

feature 'Visitor wants to view an object\'s' do 
	scenario 'Note, is on Solr view page' do
		
		create_test_object

		expect(page).to have_selector('strong', "Test Note")
		expect(page).to have_selector('p', "Test Note Type")
	end
	scenario 'Preferred Citation Note, is on Solr view page' do
		visit Path.path
		expect(page).to have_selector('strong', "Pref Note")
		expect(page).to have_selector('p', "Pref Note Type")
	end

	scenario 'Scope Content Note, is on Solr view page' do
		visit Path.path
		expect(page).to have_selector('strong', "Scope Note")
		expect(page).to have_selector('p', "Scope Note Type")
	end

	scenario 'Custodial Responsibility Note, is on Solr view page' do
		visit Path.path
		expect(page).to have_selector('strong', "Cust Note")
		expect(page).to have_selector('p', "Cust Note Type")
	end
end

def create_test_object
	sign_in_developer
	visit dams_object_path('new')

	fill_in "dams_object_titleValue_", :with => "Dams Test Object"
	fill_in "dams_object_citationNoteValue_", :with => "Pref Note"
	fill_in "Preferred Citation Type", :with => "Pref Note Type"
	fill_in "Preferred Citation Display Label", :with => "Pref Note Label"
	fill_in "dams_object_noteValue_", :with => "Test Note"
	fill_in "Note Type", :with => "Test Note Type"
	fill_in "Note Display label", :with => "Test Note Label"
	fill_in "dams_object_scopeContentNoteValue_", :with => "Scope Note"
	fill_in "Scope Content Type", :with => "Scope Note Type"
	fill_in "Scope Content Display Label", :with => "Scope Note Label"
	fill_in "dams_object_responsibilityNoteValue_", :with => "Cust Note"
	fill_in "Custodial Responsibility Type", :with => "Cust Note Type"
	fill_in "dams_object_responsibilityNoteDisplayLabel_", :with => "Cust Note Label"
 
  page.select('Research Data Curation Program', match: :first) 
  page.select('UCSD Electronic Theses and Dissertations', match: :first) 
  page.select('text', match: :first)
  page.select('English', match: :first)
  page.select('Under copyright', match: :first)

  click_on "Save"

  # Save path of object for other test(s)
  Path.path = current_path

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end