require 'spec_helper'

# Variable to be used to store MADS topic path
# Used for editing specified topic
@@path = nil

feature 'Visitor wants to create/edit a topic' do 
	scenario 'is on mads index page' do
		sign_in_developer
		# Change to create button
		visit "mads_topics/new"
		# Create new topic
		fill_in "Name", :with => "TestLabel"
		fill_in "ExternalAuthority", :with => "http://test.com"
		fill_in "TopicElement", :with => "TestElement"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# Save path of topic for other test(s)
		@@path = current_path
		expect(page).to have_content ("TestLabel")
		expect(page).to have_content ("http://test.com")
		expect(page).to have_content ("TestElement")
		expect(page).to have_content ("Test Scheme")
		expect(page).to have_content ("http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edit after Create"
		fill_in "ExternalAuthority", :with => "http://editaftercreate.edu"
		fill_in "TopicElement", :with => "Test Element2"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_content("Edit after Create")
		expect(page).to have_content("http://editaftercreate.edu")
		expect(page).to have_content("Test Element2")
		expect(page).to have_content("Test Scheme 2")
		expect(page).to have_content ("http://library.ucsd.edu/ark:/20775/")
	end

	scenario 'is on the topic page to be edited' do
		sign_in_developer
		visit @@path
		click_on "Edit"
		fill_in "Authoritative Label", :with => "Edited Test Topic"
		fill_in "ExternalAuthority", :with => "http://edited.edu"
		fill_in "TopicElement", :with => "Test Element"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_content("Edited Test Topic")
		expect(page).to have_content("http://edited.edu")
		expect(page).to have_content("Test Element")
		expect(page).to have_content("Test Scheme")
		expect(page).to have_content ("http://library.ucsd.edu/ark:/20775/")
	end
end

feature 'Visitor wants to cancel unsaved edits' do
	scenario 'is on Edit Topic page' do
		sign_in_developer
		visit @@path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "TopicElement", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Edited Test Topic")
	end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end