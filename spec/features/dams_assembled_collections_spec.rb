require 'spec_helper'

# Class to store the path of the assembled collection
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store dams assembled collection path
	# Used for editing specified collection
	@path = nil
end

# Variable to be used to store assembled collection path
# Used for editing assembled collection
feature 'Visitor wants to create/edit a assembled collection' do
	scenario 'is on dams assembled collection page' do
		sign_in_developer
		# click create button
		visit "dams_assembled_collections/new"
		# Create new dams assembled collection
		
		page.select('curator', match: :first)
		page.select('text', match: :first)
		fill_in "dams_assembled_collection_title_attributes_0_mainTitleElement_attributes_0_elementValue", :with => "TestTitle"
		fill_in "dams_assembled_collection_title_attributes_0_subTitleElement_attributes_0_elementValue", :with => "TestSubTitle"
		fill_in "dams_assembled_collection_title_attributes_0_partNameElement_attributes_0_elementValue", :with => "TestPartName"
		fill_in "dams_assembled_collection_title_attributes_0_partNumberElement_attributes_0_elementValue", :with => "TestPartNumber"
		fill_in "dams_assembled_collection_title_attributes_0_nonSortElement_attributes_0_elementValue", :with => "TestNonSort"
		fill_in "dams_assembled_collection_date_attributes_0_value", :with => "TestDate"
		fill_in "dams_assembled_collection_date_attributes_0_beginDate", :with => "2001-01-01"
		fill_in "dams_assembled_collection_date_attributes_0_endDate", :with => "2001-01-31"
		fill_in "dams_assembled_collection_date_attributes_0_type", :with => "TestDateType"
		fill_in "dams_assembled_collection_date_attributes_0_encoding", :with => "TestDateEncoding"
		#page.select('English', match: :first)
		fill_in "dams_assembled_collection_note_attributes_0_value", :with => "TestNote"
		fill_in "dams_assembled_collection_note_attributes_0_type", :with => "TestNoteType"
		fill_in "dams_assembled_collection_note_attributes_0_displayLabel", :with => "TestNoteDisplayLabel"
		fill_in "dams_assembled_collection_scopeContentNote_attributes_0_value", :with => "TestScopeContentNote"
		fill_in "dams_assembled_collection_scopeContentNote_attributes_0_type", :with => "TestScopeContentNoteType"
		fill_in "dams_assembled_collection_scopeContentNote_attributes_0_displayLabel", :with => "TestScopeContentNoteDisplayLabel"
		page.select('CorporateName', match: :first)
		page.select('artifact', match: :first)
		fill_in "dams_assembled_collection_relatedResource_attributes_0_uri", :with => "http://www.google.com"
		fill_in "dams_assembled_collection_relatedResource_attributes_0_description", :with => "TestRelatedResourceDescription"
		click_on "Save"

		# Save path of assembled collection and expect results
		Path.path = current_path
		expect(Path.path).to eq(current_path)	
		
		
		 expect(page).to have_content ("TestTitle")
		expect(page).to have_content ("TestSubTitle")
		
		expect(page).to have_content ("TestDate")
		#expect(page).to have_selector('li', :text => "English")
		expect(page).to have_content ("TestNote")
		# testing without filling in Note Displaylabel
				
		expect(page).to have_content ("ARTIFACT")
		expect(page).to have_selector('a', :text => "TestRelatedResourceDescription")
		expect(page).to have_content ("TestRelatedResourceDescription")	



		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		
		page.select('curator', match: :first)
		page.select('text', match: :first)
		fill_in "dams_assembled_collection_titleValue_", :with => "TestTitle2"
		fill_in "dams_assembled_collection_subtitle_", :with => "TestSubTitle2"
		fill_in "dams_assembled_collection_date_attributes_0_value", :with => "TestDate2"
		fill_in "dams_assembled_collection_date_attributes_0_beginDate", :with => "2001-01-01"
		fill_in "dams_assembled_collection_date_attributes_0_endDate", :with => "2001-01-31"
		fill_in "dams_assembled_collection_date_attributes_0_type", :with => "TestDateType2"
		fill_in "dams_assembled_collection_date_attributes_0_encoding", :with => "TestDateEncoding2"
		#page.select('English', match: :first)
		fill_in "dams_assembled_collection_note_attributes_0_value", :with => "TestNote2"
		fill_in "dams_assembled_collection_note_attributes_0_type", :with => "TestType2"
		fill_in "dams_assembled_collection_note_attributes_0_displayLabel", :with => "TestNoteDisplayLabel2"
		fill_in "dams_assembled_collection_scopeContentNote_attributes_0_value", :with => "TestScopeContentNote2"
		fill_in "dams_assembled_collection_scopeContentNote_attributes_0_type", :with => "TestScopeContentNoteType2"
		
		click_on "Save"

		# Check that changes are saved
		expect(page).to have_content ("TestTitle2")
		expect(page).to have_content ("TestSubTitle2")
		expect(page).to have_content ("TestDate2")
		#expect(page).to have_selector('li', :text => "English")
		expect(page).to have_content ("TestNote2")
		# should get note display label as title by not filling in Note Type
		expect(page).to have_content ("Test Note Display Label2")
	end
end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit assembled Collection page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		
		page.select('curator', match: :first)
		page.select('text', match: :first)
		fill_in "dams_assembled_collection_titleValue_", :with => "CancelTitle"
		fill_in "dams_assembled_collection_subtitle_", :with => "CancelSubTitle"
        fill_in "dams_assembled_collection_date_attributes_0_value", :with => "CancelDate"
		fill_in "dams_assembled_collection_date_attributes_0_beginDate", :with => "CancelBeginDate"
		fill_in "dams_assembled_collection_date_attributes_0_endDate", :with => "CancelEndDate"
		fill_in "dams_assembled_collection_date_attributes_0_type", :with => "CancelDateType"
		fill_in "dams_assembled_collection_date_attributes_0_encoding", :with => "CancelDateEncoding"
		#page.select('English', match: :first)
		fill_in "dams_assembled_collection_note_attributes_0_value", :with => "CancelNote"
		fill_in "dams_assembled_collection_note_attributes_0_type", :with => "CancelNoteType"
		fill_in "dams_assembled_collection_note_attributes_0_displayLabel", :with => "CancelNoteDisplaylabel"
		fill_in "dams_assembled_collection_scopeContentNote_attributes_0_value", :with => "CancelScopeContentNote"
		fill_in "dams_assembled_collection_scopeContentNote_attributes_0_type", :with => "CancelScopeContentNoteType"
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
