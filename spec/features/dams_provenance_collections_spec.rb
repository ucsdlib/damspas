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
		fill_in "First Title", :with => "TestTitle"
		fill_in "First SubTitle", :with => "TestSubTitle"
		fill_in "First PartName", :with => "TestPartName"
		fill_in "First PartNumber", :with => "TestPartNumber"
		fill_in "First NonSort", :with => "TestNonSort"
        fill_in "Date", :with => "TestDate"
        fill_in "Begin Date", :with => "TestBeginDate"
		fill_in "End Date", :with => "TestEndDate"
		fill_in "Note", :with => "TestNote"
        fill_in "Note Type", :with => "TestNoteType"
		fill_in "Note Displaylabel", :with => "TestNoteDisplaylabel"
		fill_in "Scope Content Note", :with => "TestScopeContentNote"
        fill_in "Scope Content Note Type", :with => "TestScopeContentNoteType"
        fill_in "Related Resource Type", :with => "TestRelatedResourceType"
		fill_in "Related Resource URI", :with => "TestRelatedResourceURI"
		fill_in "Related Resource Description", :with => "TestRelatedResourceDescription"
        click_on "Save"

		# Save path of provenance collection 
		Path.path = current_path
		expect(Path.path).to eq(current_path)
		expect(page).to have_content ("TestTitle")
		expect(page).to have_content ("TestSubTitle")
		expect(page).to have_content ("TestPartName")
		expect(page).to have_content ("TestPartNumber")
		expect(page).to have_content ("TestNonSort")
        expect(page).to have_content ("TestDate")
		expect(page).to have_content ("TestBeginDate")
		expect(page).to have_content ("TestEndDate")
		expect(page).to have_content ("TestNote")
		expect(page).to have_content ("TestNoteType")
		expect(page).to have_content ("TestNoteDisplaylabel")
		expect(page).to have_content ("TestScopeContentNote")
        expect(page).to have_content ("TestScopeContentNoteType")
		expect(page).to have_content ("TestRelatedResourceType")
		expect(page).to have_content ("TestRelatedResourceURI")
		expect(page).to have_content ("TestRelatedResourceDescription")

   end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
