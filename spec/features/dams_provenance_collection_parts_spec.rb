require 'spec_helper'

# Class to store the path of the provenance collection part
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store dams provenance collection part path
	# Used for editing specified collection
	@path = nil
end

# Variable to be used to store provenance collection part path
# Used for editing provenance collection part
feature 'Visitor wants to create/edit a provenance part collection' do
	scenario 'is on dams provenance collection part page' do
		sign_in_developer
		# click create button
		visit "dams_provenance_collection_parts/new"
		# Create new dams provenance collection part
		#page.select('Test Provenance Collection Part Title', match: :first)
		page.select('curator', match: :first)
		page.select('text', match: :first)
		fill_in "Title", :with => "TestTitle"
		fill_in "SubTitle", :with => "TestSubTitle"
		fill_in "PartName", :with => "TestPartName"
		fill_in "PartNumber", :with => "TestPartNumber"
		fill_in "NonSort", :with => "TestNonSort"
		fill_in "Date", :with => "TestDate"
		fill_in "Begin Date", :with => "2001-01-01"
		fill_in "End Date", :with => "2001-01-31"
		fill_in "Date Type", :with => "TestDateType"
		fill_in "Date Encoding", :with => "TestDateEncoding"
		page.select('English', match: :first)
		fill_in "Note", :with => "TestNote"
		fill_in "dams_provenance_collection_part_noteType_", :with => ""
		fill_in "dams_provenance_collection_part_noteDisplayLabel_", :with => ""
		fill_in "Scope Content Note", :with => "TestScopeContentNote"
		page.select('ConferenceName', match: :first)
		page.select('ConferenceName', match: :first)
		fill_in "Related Resource Type", :with => "TestRelatedResourceType"
		fill_in "Related Resource URI", :with => "http://www.google.com"
		fill_in "Related Resource Description", :with => "TestRelatedResourceDescription"
		click_on "Save"



		# Save path of provenance collection part and expect results
		Path.path = current_path
		expect(Path.path).to eq(current_path)	
		# expect(page).to have_selector('li', :text => "Test Provenance Collection Part Title")
		
		expect(page).to have_content ("TestTitle")
		expect(page).to have_content ("TestSubTitle")
		expect(page).to have_content ("TestPartName")
		expect(page).to have_content ("TestPartNumber")
		expect(page).to have_content ("TestNonSort")
		expect(page).to have_content ("TestDate")
		expect(page).to have_selector('li', :text => "English")
		expect(page).to have_content ("TestNote")
		# testing without filling in Note Displaylabel
		expect(page).to have_content ("General Note")
		expect(page).to have_content ("TestScopeContentNote")
		# expect(page).to have_selector('li', :text => "ConferenceName")
		# expect(page).to have_selector ('li', :text => "ConferenceName")
		expect(page).to have_content ("TESTRELATEDRESOURCETYPE")
		expect(page).to have_selector('a', :text => "TestRelatedResourceDescription")
		expect(page).to have_content ("TestRelatedResourceDescription")	



		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		#page.select('Test Title2', match: :first)
		page.select('curator', match: :first)
		page.select('text', match: :first)
		fill_in "dams_provenance_collection_part_titleValue_", :with => "TestTitle2"
		fill_in "dams_provenance_collection_part_subtitle_", :with => "TestSubTitle2"
		fill_in "dams_provenance_collection_part_titlePartName_", :with => "TestPartName2"
		fill_in "dams_provenance_collection_part_titlePartNumber_", :with => "TestPartNumber2"
		fill_in "dams_provenance_collection_part_titleNonSort_", :with => "TestNonSort2"
		fill_in "dams_provenance_collection_part_dateValue_", :with => "TestDate2"
		fill_in "dams_provenance_collection_part_beginDate_", :with => "2001-01-01"
		fill_in "dams_provenance_collection_part_endDate_", :with => "2001-01-31"
		fill_in "dams_provenance_collection_part_dateType_", :with => "TestDateType2"
		fill_in "dams_provenance_collection_part_dateEncoding_", :with => "TestDateEncoding2"
		page.select('English', match: :first)
		fill_in "dams_provenance_collection_part_noteValue_", :with => "TestNote2"
		fill_in "dams_provenance_collection_part_noteType_", :with => ""
		fill_in "dams_provenance_collection_part_noteDisplayLabel_", :with => "TestNoteDisplayLabel2"
		fill_in "dams_provenance_collection_part_scopeContentNoteValue_", :with => "TestScopeContentNote2"
		fill_in "dams_provenance_collection_part_scopeContentNoteType_", :with => "TestScopeContentNoteType"
		page.select('CorporateName', match: :first)
		fill_in "dams_provenance_collection_part_relatedResourceUri_", :with => "http://www.yahoo.com"
		fill_in "dams_provenance_collection_part_relatedResourceDescription_", :with => "TestRelatedResourceDescription2"
		click_on "Save"



		# Check that changes are saved
		# expect(page).to have_selector('li', :text => "Test Title2")
		expect(page).to have_content ("TestTitle2")
		expect(page).to have_content ("TestSubTitle2")
		expect(page).to have_content ("TestPartName2")
		expect(page).to have_content ("TestPartNumber2")
		expect(page).to have_content ("TestNonSort2")
		expect(page).to have_content ("TestDate2")
		expect(page).to have_selector('li', :text => "English")
		expect(page).to have_content ("TestNote2")
		# should get note display label as title by not filling in Note Type
		expect(page).to have_content ("TESTNOTEDISPLAYLABEL2")
		expect(page).to have_content ("TestScopeContentNote2")
		# testing without filling in Scope Content Note Type
		
		# expect(page).to have_selector('li', :text => "CorporateName")
		# expect(page).to have_selector ('li', :text => "CorporateName")
		# testing without filling in Related Resource Type
		expect(page).to have_content ("TESTRELATEDRESOURCETYPE")
		expect(page).to have_selector('a', :text => "TestRelatedResourceDescription2")
		expect(page).to have_content ("TestRelatedResourceDescription2")
  end

end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit Provenance Collection Part page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		#page.select('Test Title2', match: :first)
		page.select('curator', match: :first)
		page.select('text', match: :first)
		fill_in "dams_provenance_collection_part_titleValue_", :with => "CancelTitle"
		fill_in "dams_provenance_collection_part_subtitle_", :with => "CancelSubTitle"
		fill_in "dams_provenance_collection_part_titlePartName_", :with => "CancelPartName"
		fill_in "dams_provenance_collection_part_titlePartNumber_", :with => "CancelPartNumber"
		fill_in "dams_provenance_collection_part_titleNonSort_", :with => "CancelNonSort"
		fill_in "dams_provenance_collection_part_dateValue_", :with => "CancelDate"
		fill_in "dams_provenance_collection_part_beginDate_", :with => "CancelBeginDate"
		fill_in "dams_provenance_collection_part_endDate_", :with => "CancelEndDate"
		fill_in "dams_provenance_collection_part_dateType_", :with => "CancelDateType"
		fill_in "dams_provenance_collection_part_dateEncoding_", :with => "CancelDateEncoding"
		page.select('English', match: :first)
		fill_in "dams_provenance_collection_part_noteValue_", :with => "CancelNote"
		fill_in "dams_provenance_collection_part_noteType_", :with => "CancelNoteType"
		fill_in "dams_provenance_collection_part_noteDisplayLabel_", :with => "CancelNoteDisplaylabel"
		fill_in "dams_provenance_collection_part_scopeContentNoteValue_", :with => "CancelScopeContentNote"
		fill_in "dams_provenance_collection_part_scopeContentNoteType_", :with => "CancelScopeContentNoteType"
		page.select('CorporateName', match: :first)
		fill_in "dams_provenance_collection_part_relatedResourceType_", :with => "CancelRelatedResourceType"
		fill_in "dams_provenance_collection_part_relatedResourceUri_", :with => "http://www.test.com"
		fill_in "dams_provenance_collection_part_relatedResourceDescription_", :with => "Should not show"
		click_on "Cancel"
		visit Path.path
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("TestTitle2")
	end
end

def sign_in_developer
	visit new_user_session_path
	fill_in "name", :with => "name"
	fill_in "email", :with => "email@email.com"
	click_on "Sign In"
end
