require 'spec_helper'

feature 'Visitor wants to create a topic' do 
	scenario 'is on new mads topic page' do
		sign_in_developer
		visit "mads_topics/new"
		# Create new topic
		fill_in "Name", :with => "TestLabel"
		fill_in "ExternalAuthority", :with => "http://test.com"
		fill_in "TopicElement", :with => "Element"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"

		# On TestLabel topic page
		expect(page).to have_content ("TestLabel")
		expect(page).to have_content ("http://test.com")
		expect(page).to have_content ("Element")
		expect(page).to have_content ("Test Scheme")

		# Check index page for newly created topic
		visit mads_topics_path
		expect(page).to have_content ("TestLabel")
		all('a').select {|topic| topic.text == "TestLabel" }.last.click
		
		# Testing view
		expect(page).to have_content ("TestLabel")
		expect(page).to have_content ("http://test.com")
		expect(page).to have_content ("Element")
	end
end

feature 'Visitor wants to edit a topic' do
	scenario 'is on mads topic page' do
		sign_in_developer
		visit mads_topics_path

		# Click on first "TestLabel" topic name
		all('a').select {|topic| topic.text == "TestLabel" }.last.click
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		# Make changes
		fill_in "Authoritative Label", :with => "Edited Test Topic"
		fill_in "ExternalAuthority", :with => "http://edited.edu"
		fill_in "TopicElement", :with => "Element2"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		visit mads_topics_path
		expect(page).to have_content ("Edited Test Topic")
		all('a').select {|topic| topic.text == "Edited Test Topic" }.last.click
		expect(page).to have_content ("Edited Test Topic")
		expect(page).to have_content ("http://edited.edu")
		expect(page).to have_content ("Element2")
		expect(page).to have_content ("Test Scheme 2")
	end
end

feature 'Visitor wants to cancel unsaved edits' do
	scenario 'is on Edit Topic page' do
		sign_in_developer
		visit mads_topics_path
		all('a').select {|topic| topic.text == "Edited Test Topic" }.last.click
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Authoritative Label", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "TopicElement", :with => "Should not show"
		select("Test Scheme 2", :from => "scheme")
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