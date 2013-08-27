require 'spec_helper'

# Class to store the path of the geographic
class Path
	class << self
		attr_accessor :path
	end
	# Variable to be used to store MADS Geographic path
	# Used for editing specified geographic
	@path = nil
end

feature 'Visitor wants to create/edit a MADS Geographic' do
  let!(:scheme1) { MadsScheme.create!(name: 'Test Scheme 3') }
  let!(:scheme2) { MadsScheme.create!(name: 'Test Scheme 4') }

  after do
    scheme1.destroy
    scheme2.destroy
  end
  
	scenario 'is on new MADS Geographic page' do
		sign_in_developer
		visit "mads_topics"
		expect(page).to have_selector('a', :text => "Create Topic")

		# Change to create button
		visit "mads_geographics/new"
		# Create new geographic
		fill_in "Name", :with => "Test Geographic"
		fill_in "ExternalAuthority", :with => "http://geographic.com"
		fill_in "Element Value", :with => "Mountain"
		select('Test Scheme 3', from: 'Scheme')  
		click_on "Submit"

		# Save path of geographic for other test(s)
		Path.path = current_path
		expect(Path.path).to eq(current_path)
		#expect(page).to have_selector('strong', :text => "Test Geographic")
		expect(page).to have_selector('a', :text => "http://geographic.com")
		expect(page).to have_selector('li', :text => "Mountain")
		expect(page).to have_selector('li', :text => "Test Scheme 3")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")

		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "Edit Geographic after Create"
		fill_in "ExternalAuthority", :with => "http://editgeoaftercreate.edu"
		fill_in "Element Value", :with => "Hills"
		select('Test Scheme 4', match: :first) 
		click_on "Save changes"

		# Check that changes are saved
		#expect(page).to have_selector('strong', :text => "Edit Geographic after Create")
		expect(page).to have_selector('a', :text => "http://editgeoaftercreate.edu")
		expect(page).to have_selector('li', :text => "Hills")
		expect(page).to have_selector('li', :text => "Test Scheme 4")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

	scenario 'is on the Geographic page to be edited' do
		sign_in_developer

		visit Path.path
		click_on "Edit"
		fill_in "Name", :with => "Edited Geographic"
		fill_in "ExternalAuthority", :with => "http://editedgeo.edu"
		fill_in "Element Value", :with => "Road"
		select('Test Scheme 4', match: :first) 
		click_on "Save changes"
		#expect(page).to have_selector('strong', :text => "Edited Geographic")
		expect(page).to have_selector('a', :text => "http://editedgeo.edu")
		expect(page).to have_selector('li', :text => "Road")
		expect(page).to have_selector('li', :text => "Test Scheme 4")
		expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
	end

end

feature 'Visitor wants to cancel unsaved edits' do
  let!(:scheme1) { MadsScheme.create!(name: 'Test Scheme 3') }
  let!(:scheme2) { MadsScheme.create!(name: 'Test Scheme 4') }

  after do
    scheme1.destroy
    scheme2.destroy
  end	
	scenario 'is on Edit Geographic page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "Name", :with => "CANCEL"
		fill_in "ExternalAuthority", :with => "http://cancel.edu"
		fill_in "Element Value", :with => "Should not show"
		page.select('Test Scheme 4', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
		expect(page).to have_content("Road")
	end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
