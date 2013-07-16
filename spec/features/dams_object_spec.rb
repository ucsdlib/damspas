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

feature 'Visitor wants to create/edit a DAMS Object' do

  scenario 'is on new DAMS Object page' do
    sign_in_developer

    visit dams_object_path('new')
    # Create new object
    fill_in "First Title", :with => "Dams Test Object"
    fill_in "First SubTitle", :with => "New Object"
    fill_in "First PartName", :with => "ep1"
    fill_in "First PartNumber", :with => "999"
    fill_in "First NonSort", :with => "this"
    fill_in "Type Of Resource", :with => "Book"
    page.select('Library Digital Collections', match: :first) 
    page.select('UCSD Electronic Theses and Dissertations', match: :first) 
    fill_in "Date", :with => "07/15/2013"
    fill_in "Begin Date", :with => "07/11/2013"
    fill_in "End Date", :with => "07/15/2013"
    fill_in "Note", :with => "Test object"
    fill_in "Note Displaylabel", :with => "Tester"
    fill_in "Scope Content Note", :with => "TestScope"
    fill_in "Scope Content Note Type", :with => "Current Scope"
    fill_in "Subject 1", match: :first, :with => "Math"
    fill_in "Subject 2", match: :first, :with => "Physics"
    fill_in "dams_object_subjectTypeValue_", :with => "TypeSubject"
    fill_in "dams_object_relationshipNameValue_", :with => "John Doe"
    fill_in "Related Resource Type", :with => "Person"
    fill_in "Related Resource URI", :with => "http://JohnDoe.com"
    fill_in "Related Resource Description", :with => "Mathematician"
    click_on "Submit"

    # Save path of object for other test(s)
    Path.path = current_path
    expect(page).to have_selector('h1', :text => "Dams Test Object")
    expect(page).to have_selector('h2', :text => "New Object")
    expect(page).to have_selector('a', :text => "UCSD Electronic Theses and Dissertations")
    expect(page).to have_selector('a', :text => "Library Digital Collections")
    expect(page).to have_selector('li', :text => "07/15/2013")
    expect(page).to have_selector('a', :text => "Book")
    expect(page).to have_selector('a', :text => "Physics")

    expect(page).to have_selector('strong', :text => "TESTER")
    expect(page).to have_selector('p', :text => "Test object")
    expect(page).to have_selector('a', :text => "Mathematician")

    click_on "Edit"
    # fill_in "Title", :with => "Edit Dams Object"
    # fill_in "Date", :with => "07/16/2013"
    # fill_in "Subject", :with => "Science"
    # click_on "Save changes"

    # # Check that changes are saved
    # expect(page).to have_selector('a', :text => "Science")
    # expect(page).to have_selector('li', :text => "07/16/2013")
    # expect(page).to have_selector('h1', :text => "Dams Test Object")
    # expect(page).to have_selector('li', :text => "Test Scheme 2")
    # expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
  end

  # scenario 'is on the Object page to be edited' do
  #   sign_in_developer

  #   visit Path.path
  #   click_on "Edit"
  #   fill_in "Authoritative Label", :with => "Final Object"
  #   fill_in "ExternalAuthority", :with => "http://finalobject.edu"
  #   fill_in "ObjectElement", :with => "Everything"
  #   page.select('Test Scheme', match: :first) 
  #   click_on "Save changes"
  #   expect(page).to have_selector('strong', :text => "Final Object")
  #   expect(page).to have_selector('a', :text => "http://finalobject.edu")
  #   expect(page).to have_selector('li', :text => "Everything")
  #   expect(page).to have_selector('li', :text => "Test Scheme")
  #   expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
  # end

end

feature 'Visitor wants to cancel unsaved edits' do
  
  scenario 'is on Edit Object page' do
    sign_in_developer
    visit Path.path
    expect(page).to have_selector('a', :text => "Edit")
    click_on "Edit"
    fill_in "Title", :with => "Nothing"
    fill_in "Date", :with => "07/16/2013"
    fill_in "Subject", :with => "Should not show"
    click_on "Cancel"
    expect(page).to_not have_content("Should not show")
    expect(page).to have_content("Dams Test Object")
  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end
