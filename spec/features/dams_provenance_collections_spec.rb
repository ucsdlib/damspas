require 'spec_helper'

# Class to store the path of the provenance collection
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store dams provenance collection path
	# Used for editing specified collection
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
		page.select('Provenance Collection Part Test Title', match: :first)
		fill_in "Title", :with => "TestTitle"
		fill_in "SubTitle", :with => "TestSubTitle"
		fill_in "PartName", :with => "TestPartName"
		fill_in "PartNumber", :with => "TestPartNumber"
		fill_in "NonSort", :with => "TestNonSort"
		fill_in "Date", :with => "TestDate"
		fill_in "Begin Date", :with => "TestBeginDate"
		fill_in "End Date", :with => "TestEndDate"
		page.select('Test Language 2', match: :first)
		fill_in "Note", :with => "TestNote"
		fill_in "dams_provenance_collection_noteType_", :with => ""
		fill_in "dams_provenance_collection_noteDisplayLabel_", :with => ""
		fill_in "Scope Content Note", :with => "TestScopeContentNote"
		page.select('ConferenceName', match: :first)
		page.select('ConferenceName', match: :first)
		fill_in "Related Resource Type", :with => "TestRelatedResourceType"
		fill_in "Related Resource URI", :with => "http://www.google.com"
		fill_in "Related Resource Description", :with => "TestRelatedResourceDescription"
		click_on "Save"



		# Save path of provenance collection and expect results
		Path.path = current_path
		expect(Path.path).to eq(current_path)	
		# expect(page).to have_selector('li', :text => "Provenance Collection Part Test Title")
		expect(page).to have_content ("TestTitle")
		expect(page).to have_content ("TestSubTitle")
		expect(page).to have_content ("TestPartName")
		expect(page).to have_content ("TestPartNumber")
		expect(page).to have_content ("TestNonSort")
		expect(page).to have_content ("TestDate")
		expect(page).to have_content ("TestBeginDate")
		expect(page).to have_content ("TestEndDate")
		expect(page).to have_selector('li', :text => "Test Language 2")
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
		page.select('Test Title2', match: :first)
		fill_in "dams_provenance_collection_titleValue_", :with => "TestTitle2"
		fill_in "dams_provenance_collection_subtitle_", :with => "TestSubTitle2"
		fill_in "dams_provenance_collection_titlePartName_", :with => "TestPartName2"
		fill_in "dams_provenance_collection_titlePartNumber_", :with => "TestPartNumber2"
		fill_in "dams_provenance_collection_titleNonSort_", :with => "TestNonSort2"
		fill_in "dams_provenance_collection_dateValue_", :with => "TestDate2"
		fill_in "dams_provenance_collection_beginDate_", :with => "TestBeginDate2"
		fill_in "dams_provenance_collection_endDate_", :with => "TestEndDate2"
		page.select('Test Language', match: :first)
		fill_in "dams_provenance_collection_noteValue_", :with => "TestNote2"
		fill_in "dams_provenance_collection_noteType_", :with => ""
		fill_in "dams_provenance_collection_noteDisplayLabel_", :with => "TestNoteDisplayLabel2"
		fill_in "dams_provenance_collection_scopeContentNoteValue_", :with => "TestScopeContentNote2"
		fill_in "dams_provenance_collection_scopeContentNoteType_", :with => "TestScopeContentNoteType"
		page.select('CorporateName', match: :first)
		fill_in "dams_provenance_collection_relatedResourceUri_", :with => "http://www.yahoo.com"
		fill_in "dams_provenance_collection_relatedResourceDescription_", :with => "TestRelatedResourceDescription2"
		click_on "Save"



		# Check that changes are saved
		# expect(page).to have_selector('li', :text => "Test Title2")
		expect(page).to have_content ("TestTitle2")
		expect(page).to have_content ("TestSubTitle2")
		expect(page).to have_content ("TestPartName2")
		expect(page).to have_content ("TestPartNumber2")
		expect(page).to have_content ("TestNonSort2")
		expect(page).to have_content ("TestDate2")
		expect(page).to have_content ("TestBeginDate2")
		expect(page).to have_content ("TestEndDate2")
		expect(page).to have_selector('li', :text => "Test Language")
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

# scenario 'is on the provenance collection page to be edited' do
# 	sign_in_developer

# 	visit Path.path
# 	click_on "Edit"
# 	page.select('Test Title2', match: :first)

# 	fill_in "dams_provenance_collection_titleValue_", :with => "TestTitle3"
# 	fill_in "dams_provenance_collection_subtitle_", :with => "TestSubTitle3"
# 	fill_in "dams_provenance_collection_titlePartName_", :with => "TestPartName3"
# 	fill_in "dams_provenance_collection_titlePartNumber_", :with => "TestPartNumber3"
# 	fill_in "dams_provenance_collection_titleNonSort_", :with => "TestNonSort3"
# 	fill_in "dams_provenance_collection_dateValue_", :with => "TestDate3"
# 	fill_in "dams_provenance_collection_beginDate_", :with => "TestBeginDate3"
# 	fill_in "dams_provenance_collection_endDate_", :with => "TestEndDate3"
# 	page.select('Test Language', match: :first)
# 	fill_in "dams_provenance_collection_noteValue_", :with => "TestNote3"
# 	fill_in "dams_provenance_collection_noteType_", :with => "TESTNOTETYPE3"
# 	fill_in "dams_provenance_collection_noteDisplayLabel_", :with => " "
# 	fill_in "dams_provenance_collection_scopeContentNoteValue_", :with => "TestScopeContentNote3"
# 	page.select('CorporateName', match: :first)
# 	fill_in "dams_provenance_collection_relatedResourceType_", :with => "TestRelatedResourceType3"
# 	fill_in "dams_provenance_collection_relatedResourceUri_", :with => "http://www.amazon.com"
# 	fill_in "dams_provenance_collection_relatedResourceDescription_", :with => "TestRelatedResourceDescription3"
# 	click_on "Save"



# 	# Check that changes are saved
# 	# expect(page).to have_selector('li', :text => "Test Title2")
# 	expect(page).to have_content ("TestTitle3")
# 	expect(page).to have_content ("TestSubTitle3")
# 	expect(page).to have_content ("TestPartName3")
# 	expect(page).to have_content ("TestPartNumber3")
# 	expect(page).to have_content ("TestNonSort3")
# 	expect(page).to have_content ("TestDate3")
# 	expect(page).to have_content ("TestBeginDate3")
# 	expect(page).to have_content ("TestEndDate3")
# 	expect(page).to have_selector('li', :text => "Test Language")
# 	expect(page).to have_content ("TestNote3")
# 	# should get note type as title by not filling in Note Display Lable
# 	expect(page).to have_content ("TESTNOTETYPE3")
# 	expect(page).to have_content ("TestScopeContentNote3")
# 	# expect(page).to have_selector('li', :text => "CorporateName")
# 	# expect(page).to have_selector ('li', :text => "CorporateName")
# 	expect(page).to have_content ("TESTRELATEDRESOURCETYPE3")
# 	expect(page).to have_selector('a', :text => "TestRelatedResourceDescription3")
# 	expect(page).to have_content ("TestRelatedResourceDescription3")
# 	end
end

feature 'Visitor wants to cancel unsaved edits' do

	# scenario 'is on Edit Provenance Collection page' do
	# 	sign_in_developer
	# 	visit Path.path
	# 	expect(page).to have_selector('a', :text => "Edit")
	# 	click_on "Edit"
	# 	page.select('Test Title2', match: :first)
	# 	fill_in "dams_provenance_collection_titleValue_", :with => "CancelTitle"
	# 	fill_in "dams_provenance_collection_subtitle_", :with => "CancelSubTitle"
	# 	fill_in "dams_provenance_collection_titlePartName_", :with => "CancelPartName"
	# 	fill_in "dams_provenance_collection_titlePartNumber_", :with => "CancelPartNumber"
	# 	fill_in "dams_provenance_collection_titleNonSort_", :with => "CancelNonSort"
	# 	fill_in "dams_provenance_collection_dateValue_", :with => "CancelDate"
	# 	fill_in "dams_provenance_collection_beginDate_", :with => "CancelBeginDate"
	# 	fill_in "dams_provenance_collection_endDate_", :with => "CancelEndDate"
	# 	page.select('Test Language', match: :first)
	# 	fill_in "dams_provenance_collection_noteValue_", :with => "CancelNote"
	# 	fill_in "dams_provenance_collection_noteType_", :with => "CancelNoteType"
	# 	fill_in "dams_provenance_collection_noteDisplayLabel_", :with => "CancelNoteDisplaylabel"
	# 	fill_in "dams_provenance_collection_scopeContentNoteValue_", :with => "CancelScopeContentNote"
	# 	fill_in "dams_provenance_collection_scopeContentNoteType_", :with => "CancelScopeContentNoteType"
	# 	page.select('CorporateName', match: :first)
	# 	fill_in "dams_provenance_collection_relatedResourceType_", :with => "CancelRelatedResourceType"
	# 	fill_in "dams_provenance_collection_relatedResourceUri_", :with => "http://www.test.com"
	# 	fill_in "dams_provenance_collection_relatedResourceDescription_", :with => "Should not show"
	# 	click_on "Cancel"
	# 	expect(page).to_not have_content("Should not show")
	# 	expect(page).to have_content("TestTitle2")
	# end
end

def sign_in_developer
	visit new_user_session_path
	fill_in "Name", :with => "name"
	fill_in "Email", :with => "email@email.com"
	click_on "Sign In"
end
