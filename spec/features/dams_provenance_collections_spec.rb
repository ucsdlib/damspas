require 'spec_helper'

# Class to store the path of the provenance collection
class Path
	class << self
		attr_accessor :path
	end
	@path = nil
end

# Variable to be used to store provenance collection path
# Used for editing provenance collection
feature 'Visitor wants to create/edit a provenance collection' do 
	scenario 'is on dams provenance collection page' do
		sign_in_developer
		# click create button
		visit "dams_provenance_collections/new"
		# Create new dams provenance collection
		fill_in "Title", :with => "TestTitle"
		fill_in "SubTitle", :with => "TestSubTitle"
		fill_in "PartName", :with => "TestPartName"
		fill_in "PartNumber", :with => "TestPartNumber"
		fill_in "NonSort", :with => "TestNonSort"
		fill_in "Date", :with => "TestDate"
		#fill_in "Begin Date", :with => "TestBeginDate"
		#fill_in "End Date", :with => "TestEndDate"
		fill_in "Note", :with => "TestNote"
		fill_in "Note Type", :with => "TestNoteType"
		fill_in "Note Displaylabel", :with => "TestNoteDisplaylabel"
		fill_in "Scope Content Note", :with => "TestScopeContentNote"
		fill_in "Scope Content Note Type", :with => "TestScopeContentNoteType"
		#page.select('Test Simple Subject', match: :first) 
		#fill_in "Simple Subject", :with => "TestSimpleSubject"
		#page.select('Test Complex Subject', match: :first) 
		#fill_in "Complex Subject", :with => "TestComplexSubject"
		fill_in "Related Resource Type", :with => "TestRelatedResourceType"
		fill_in "Related Resource URI", :with => "TestRelatedResourceURI"
		fill_in "Related Resource Description", :with => "TestRelatedResourceDescription"
		#page.select('Test Language', match: :first) 
		#page.select('Test dams object', match: :first) 
		#page.select('Test Provenance Collection Part', match: :first) 
		click_on "Save"

		# Save path of provenance collection and expect results
		Path.path = current_path
		expect(Path.path).to eq(current_path)
		expect(page).to have_content ("TestTitle")
		expect(page).to have_content ("TestSubTitle")
		expect(page).to have_content ("TestPartName")
		expect(page).to have_content ("TestPartNumber")
		expect(page).to have_content ("TestNonSort")
		expect(page).to have_content ("TestDate")
		#expect(page).to have_content ("TestBeginDate")
		#expect(page).to have_content ("TestEndDate")
		expect(page).to have_content ("TestNote")
		expect(page).to have_content ("TestNoteType")
		expect(page).to have_content ("TestNoteDisplaylabel")
		expect(page).to have_content ("TestScopeContentNote")
		expect(page).to have_content ("TestScopeContentNoteType")
		#expect(page).to have_content ("Test Simple Subject")
		#expect(page).to have_content ("TestSimpleSubject")
		#expect(page).to have_content ("Test Complex Subject")
		#expect(page).to have_content ("TestComplexSubject")
		expect(page).to have_content ("TestRelatedResourceType")
		expect(page).to have_content ("TestRelatedResourceURI")
		expect(page).to have_content ("TestRelatedResourceDescription")
		#expect(page).to have_content ("Test Language")
		#expect(page).to have_content ("Test dams object")
		#expect(page).to have_content ("Test Provenance Collection Part")

	end
end

def sign_in_developer
	visit new_user_session_path
	fill_in "Name", :with => "name"
	fill_in "Email", :with => "email@email.com"
	click_on "Sign In"
end