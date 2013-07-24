require 'spec_helper'
require 'rack/test'

feature 'Visitor want to look at objects' do

  scenario 'view a sample object record' do
    visit dams_object_path('bb55555555')
    expect(page).to have_selector('h1',:text=>'Sample Complex Object Record #3')
    expect(page).to have_link('http://library.ucsd.edu/ark:/20775/bb55555555', href: 'http://library.ucsd.edu/ark:/20775/bb55555555')
  end

  scenario 'view a sample data file' do
    visit file_path('bb55555555','_5_5.jpg')
    response = page.driver.response
    expect(response.status).to eq( 200 )
    expect(response.header["Content-Type"]).to eq( "image/jpeg" )
  end

  scenario 'view a non-existent record' do
    expect { visit dams_object_path('xxx') }.to raise_error(
      ActionController::RoutingError)
  end

  scenario 'view a file from a non-existing object' do
    expect { visit file_path('xxx','xxx') }.to raise_error(
      ActionController::RoutingError)
  end

  scenario 'view a non-existing file from an existing object' do
    expect { visit file_path('bb55555555','xxx') }.to raise_error(
      ActionController::RoutingError)
  end

end

# Class to store the path of the object
class Path
  class << self
    attr_accessor :path
  end
  # Variable to be used to store DAMS Object path
  # Used for editing specified object
  @path = nil
end


# Need Test Language, Copyright, Select collection

feature 'Visitor wants to create/edit a DAMS Object' do

  scenario 'is on new DAMS Object Create page' do
    sign_in_developer

    visit dams_object_path('new')
    # Create new object
    fill_in "dams_object_titleValue_", :with => "Dams Test Object"
    fill_in "SubTitle", :with => "New Object"
    fill_in "PartName", :with => "ep1"
    fill_in "PartNumber", :with => "999"
    fill_in "NonSort", :with => "this"
    page.select('Research Data Curation Program', match: :first) 
    page.select('UCSD Electronic Theses and Dissertations', match: :first) 
    fill_in "dams_object_dateValue_", :with => "07/15/2013"
    fill_in "Begin Date", :with => "07/11/2013"
    fill_in "End Date", :with => "07/15/2013"
    page.select('text', match: :first)
    fill_in "dams_object_subjectTypeValue_", :with => "TypeSubject"
    fill_in "Type", :with => "Person"
    fill_in "URI", :with => "http://JohnDoe.com"
    fill_in "Description", :with => "Mathematician"
    page.select('Test Copyright')
    fill_in "Point", :with => "98"
    fill_in "Scale", :with => "100%"

    click_on "Save"

    # Save path of object for other test(s)
    Path.path = current_path
    expect(page).to have_selector('h1', :text => "Dams Test Object")
    expect(page).to have_selector('h2', :text => "New Object")
    expect(page).to have_selector('a', :text => "UCSD Electronic Theses and Dissertations")
    expect(page).to have_selector('a', :text => "Research Data Curation Program")
    expect(page).to have_selector('li', :text => "07/15/2013")
    expect(page).to have_selector('a', :text => "Text")
    expect(page).to have_selector('strong', :text => "Test Copyright")
    expect(page).to have_selector('a', :text => "Mathematician")

    click_on "Edit"
    fill_in "dams_object_titleValue_", :with => "Edited Dams Object"
    fill_in "dams_object_dateValue_", :with => "07/16/2013", match: :first
    fill_in "dams_object_noteValue_", :with => "Science"
    fill_in "Description", :with => "Student"
    page.select('Library Digital Collections', match: :first)
    click_on "Save"

    # Check that changes are saved
    expect(page).to have_selector('p', :text => "Science")
    expect(page).to have_selector('li', :text => "07/16/2013")
    expect(page).to have_selector('h1', :text => "Edited Dams Object")
    expect(page).to have_selector('a', :text => "Library Digital Collections")
    expect(page).to have_selector('li', :text => "Student")

    # Check Hydra View
    click_on "Hydra View"
    expect(page).to have_content("Begin Date: 07/11/2013")
    expect(page).to have_content("Edited Dams Object")

    click_on "New Object"
    expect(current_path).to eq(dams_object_path('new'))

  end

  scenario 'is on the Object page to be edited' do
    sign_in_developer

    visit Path.path
    click_on "Edit"
    fill_in "dams_object_titleValue_", :with => "Final Dams Object"
    fill_in "Note Displaylabel", :with => "Displays"
    page.select('still image', match: :first)


    click_on "Save"
    expect(page).to have_selector('h1', :text => "Final Dams Object")
    expect(page).to have_selector('strong', :text => "DISPLAYS")
    expect(page).to have_selector('a', :text => "Still Image")
  end

end

feature 'Visitor wants to cancel unsaved objects' do
  
  scenario 'is on Edit Object page' do
    sign_in_developer
    visit Path.path
    expect(page).to have_selector('a', :text => "Edit")
    click_on "Edit"
    fill_in "Title", :with => "Nothing"
    fill_in "Date", :with => "07/23/2013", match: :first
    fill_in "dams_object_noteValue_", :with => "Should not show"
    click_on "Cancel"
    expect(page).to_not have_content("Should not show")
    expect(page).to have_content("Final Dams Object")
  end

  scenario 'is on Create Object page' do
    sign_in_developer
    visit dams_object_path('new')
    fill_in "dams_object_titleValue_", :with => "BROKEN"
    fill_in "dams_object_dateValue_", :with => "NO DATE"
    click_on "Cancel"
    expect(current_path).to eq('/dams_units')
  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
