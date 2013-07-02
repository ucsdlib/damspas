require 'spec_helper'

feature 'Visitor wants to create a topic' do 
	scenario 'is on new mads topic page' do
		sign_in_developer
		visit "mads_topics/new"
		# Create new topic
		fill_in "Name", :with => "TestLabel"
		fill_in "externalAuthority", :with => "http://test.com"
		click_on "Submit"

		# On TestLabel topic page
		expect(page).to have_content ("TestLabel")
		# expect(page).to have_content ("http://test.com")

		# Check index page for newly created topic
		visit mads_topics_path
		expect(page).to have_content ("TestLabel")
		click_on "TestLabel"
		expect(page).to have_content ("TestLabel")
		# expect(page).to have_content ("http://test.com")
	end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end