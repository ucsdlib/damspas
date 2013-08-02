require 'spec_helper'

# Class to store the path of the topic
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS topic path
	# Used for editing specified topic
	@path = nil
end

feature 'Visitor wants to create/edit a topic' do
  let!(:scheme1) { MadsScheme.create!(name: 'Test Scheme') }
  let!(:scheme2) { MadsScheme.create!(name: 'Test Scheme 2') }

  after do
    scheme1.destroy
    scheme2.destroy
  end

	scenario 'is on mads index page' do
		sign_in_developer
		# Change to create button
		visit "mads_topics/new"
		# Create new topic
		fill_in "Name", :with => "TestLabel"
		fill_in "ExternalAuthority", :with => "http://test.com"
		fill_in "Element Value", :with => "TestElement"
		page.select('Test Scheme', match: :first) 
		click_on "Submit"


		# Save path of topic for other test(s)
		Path.path = current_path
		expect(Path.path).to eq(current_path)
    # the name gets overwritten by what is in the "Element Value", so this test no longer makes sense.
		#expect(page).to have_selector('strong', :text => "TestLabel")
		expect(page).to have_selector('a', :text => "http://test.com")
		expect(page).to have_selector('li', :text => "TestElement")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "Edit after Create"
		fill_in "ExternalAuthority", :with => "http://editaftercreate.edu"
		fill_in "Element Value", :with => "Test Element2"
		page.select('Test Scheme 2', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		expect(page).to have_selector('a', :text => "http://editaftercreate.edu")
		expect(page).to have_selector('li', :text => "Test Element2")
		expect(page).to have_selector('li', :text => "Test Scheme 2")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
        # this is being overridden by element value (see https://github.com/ucsdlib/damspas/issues/21)
		#expect(page).to have_selector('strong', :text => "Edit after Create")
	end

	scenario 'is on the topic page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Name", :with => "Edited Test Topic"
		fill_in "Name", :with => "Edited Test Topic"
		fill_in "ExternalAuthority", :with => "http://edited.edu"
		fill_in "Element Value", :with => "Test Element"
		page.select('Test Scheme', match: :first) 
		click_on "Save changes"
		expect(page).to have_selector('a', :text => "http://edited.edu")
		expect(page).to have_selector('li', :text => "Test Element")
		expect(page).to have_selector('li', :text => "Test Scheme")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
        # getting overriden by element value
		#expect(page).to have_selector('strong', :text => "Edited Test Topic")
	end

end

feature 'Visitor wants to cancel unsaved edits' do

	scenario 'is on Edit Topic page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "Element Value", :with => "Should not show"
		page.select('Test Scheme 2', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Test Element")
        # overridden by test element
		#expect(page).to have_content("Edited Test Topic")
	end
	
end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
