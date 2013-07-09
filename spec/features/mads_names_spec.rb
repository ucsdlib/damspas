require 'spec_helper'

# Helper class to store the path of the name
class Path
  class << self
    attr_accessor :path
  end
  # Variable to be used to store MADS Name path
  # Used for editing specified name
  @path = nil
end


feature 'Visitor wants to create/edit a MADS Name' do 

  scenario 'is on new MADS Name page' do
    sign_in_developer

    visit mads_name_path('new')

    # Create new name
    fill_in "Name", :with => "John Doe"
    fill_in "ExternalAuthority", :with => "http://johndoe.com"
    fill_in "FullNameElement", :with => "John James Doe"
    fill_in "FamilyNameElement", :with => "Doe1"
    fill_in "GivenNameElement", :with => "Johnson"
    fill_in "DateNameElement", :with => "1900"
    fill_in "TermOfAddressElement", :with => "First"
    page.select("Test Scheme", match: :first)
    click_on "Submit"
    Path.path = current_path

    expect(page).to have_selector('strong', :text => "John Doe")
    expect(page).to have_selector('li', :text => "John James Doe")
    expect(page).to have_selector('li', :text => "Doe1")
    expect(page).to have_selector('li', :text => "Johnson")
    expect(page).to have_selector('li', :text => "1900")
    expect(page).to have_selector('li', :text => "First")
    expect(page).to have_selector('li', :text => "Test Scheme")
    expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
    expect(page).to have_selector('a', :text => "http://johndoe.com")


  end

  scenario 'is on Edit Name page' do
    sign_in_developer
    visit Path.path

    click_on "Edit"
    fill_in "Authoritative Label", :with => "Jane Does"
    fill_in "ExternalAuthority", :with => "http://nameauthority.com"
    page.select("Test Scheme 2", match: :first)
    fill_in "FullNameElement", :with => "Jane Does1"
    fill_in "FamilyNameElement", :with => "Doese"
    fill_in "GivenNameElement", :with => "Janer"
    fill_in "DateNameElement", :with => "1950"
    fill_in "TermOfAddressElement", :with => "Last"
    click_on "Save changes"

    expect(page).to have_selector('strong', :text => "Jane Does")
    expect(page).to have_selector('li', :text => "Jane Does1")
    expect(page).to have_selector('li', :text => "Doese")
    expect(page).to have_selector('li', :text => "Janer")
    expect(page).to have_selector('li', :text => "1950")
    expect(page).to have_selector('li', :text => "Last")
    expect(page).to have_selector('li', :text => "Test Scheme 2")
    expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/")
    expect(page).to have_selector('a', :text => "http://nameauthority.com")

  end

end

feature 'Visitor wants to cancel unsaved edits' do

  scenario 'is on Edit Name page' do
    sign_in_developer
    visit Path.path
    expect(page).to have_selector('a', :text => "Edit")
    click_on "Edit"
    fill_in "Authoritative Label", :with => "Cancel"
    fill_in "ExternalAuthority", :with => "http://cancel.com"
    page.select("Test Scheme 2", match: :first)
    fill_in "FullNameElement", :with => "Can Cel"
    fill_in "FamilyNameElement", :with => "Cel"
    fill_in "GivenNameElement", :with => "Can"
    fill_in "DateNameElement", :with => "1999"
    fill_in "TermOfAddressElement", :with => "Not here"
    click_on "Cancel"
    expect(page).to_not have_content("Can Cel")
    expect(page).to have_content("Jane Does")
  end

end

feature 'Visitor wants to use Hydra View' do
  
  scenario 'is on Name view page' do
    sign_in_developer
    visit Path.path
    click_on "Hydra View"
    expect(page).to have_selector('h1', :text => "Jane Does")
    expect(page).to have_selector('dd', :text => "Jane Does1")
    expect(page).to have_selector('dd', :text => "Doese")
    expect(page).to have_selector('dd', :text => "Janer")
    expect(page).to have_selector('dd', :text => "1950")
    expect(page).to have_selector('dd', :text => "Last")
    expect(page).to have_selector('dd', :text => "http://library.ucsd.edu/ark:/20775/")
    expect(page).to have_selector('dd', :text => "http://nameauthority.com")
    click_on "Edit"
  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end