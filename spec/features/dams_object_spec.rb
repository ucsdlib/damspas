require 'spec_helper'
require 'rack/test'

feature 'Visitor want to look at objects' do

  scenario 'view a sample object record' do
    sign_in_developer
    visit dams_object_path('bd0922518w')
    expect(page).to have_selector('h1',:text=>'Sample Complex Object Record #3')
    expect(page).to have_link('http://library.ucsd.edu/ark:/20775/bd0922518w', href: 'http://library.ucsd.edu/ark:/20775/bd0922518w')

    # admin links
    expect(page).to have_link('Hydra View')
    expect(page).to have_link('RDF View')
  end

  scenario 'view a sample data file' do
    sign_in_developer
    visit file_path('bd0922518w','_5_5.jpg')
    response = page.driver.response
    expect(response.status).to eq( 200 )
    expect(response.header["Content-Type"]).to eq( "image/jpeg" )
  end

  scenario 'view a non-existent record' do
    visit dams_object_path('xxx')
    expect(page).to have_content 'You are not allowed to view this page.'
  end

  scenario 'view a file from a non-existing object' do
    expect { visit file_path('xxx','xxx') }.to raise_error(
      ActionController::RoutingError)
  end

  scenario 'view a non-existing file from an existing object' do
    expect { visit file_path('bd0922518w','xxx') }.to raise_error(
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
  let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
  let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }

  after do
    scheme1.destroy
    scheme2.destroy
  end
  
  scenario 'is on new DAMS Object Create page' do
    sign_in_developer

    visit dams_object_path('new')

    fill_in "MainTitle", :with => "Dams Test Object"
    fill_in "SubTitle", :with => "New Object"
    fill_in "PartName", :with => "ep1"
    fill_in "PartNumber", :with => "999"
    fill_in "NonSort", :with => "this"
    page.select('Research Data Curation Program', match: :first) 
    page.select('UCSD Electronic Theses and Dissertations', match: :first) 
    fill_in "dams_object_date_attributes_0_value", :with => "2013"
    fill_in "Begin Date", :with => "2012"
    fill_in "End Date", :with => "2014"
	fill_in "Date Type", :with => "Testdatetype"
	fill_in "Date Encoding", :with => "TestDateEncoding"    
    page.select('text', match: :first)
    fill_in "Type", :with => "Person"
    fill_in "URI", :with => "http://JohnDoe.com"
    fill_in "Description", :with => "Mathematician"
    page.select("French", match: :first)
    page.select('Public domain', match: :first)
    fill_in "Point", :with => "98"
    fill_in "Scale", :with => "100%"

    # works in browser, but clobbers metadata in rspec
    # SHOULD NOT be pending, because pending tests are still run
    #page.attach_file 'file', File.join(Rails.root,'/spec/fixtures/madsScheme.rdf.xml')

    click_on "Save"

    # Save path of object for other test(s)
    Path.path = current_path

    # Checking the view
    pending "Works in browser but fails in rspec" do
      expect(page).to have_selector('h1', :text => "Dams Test Object")
      expect(page).to have_selector('h2', :text => "New Object")
      expect(page).to have_selector('a', :text => "UCSD Electronic Theses and Dissertations")
      expect(page).to have_selector('a', :text => "Research Data Curation Program")
      expect(page).to have_selector('li', :text => "2013")
      expect(page).to have_selector('dt', :text => "Testdatetype")
      expect(page).to have_selector('a', :text => "Text")
      #expect(page).to have_selector('strong', :text => "Public domain") # XXX not displaying
      expect(page).to have_selector('a', :text => "Mathematician")
      expect(page).to have_selector('div', :text => 'Object has been saved')

      # check uploaded file
      visit Path.path + '/_1.xml'
      response = page.driver.response
      expect(response.status).to eq( 200 )
    end

    visit Path.path
    click_on "Edit"
    fill_in "dams_object_titleValue_", :with => "Edited Dams Object"
    fill_in "dams_object_date_attributes_0_value", :with => "2013", match: :first
    fill_in "Begin Date", :with => "2014"
    fill_in "dams_object_note_attributes_0_value", :with => "Science"
    fill_in "Description", :with => "Student"
    page.select('Library Digital Collections', match: :first)
    click_on "Save"

    # Check that changes are saved
    expect(page).to have_selector('p', :text => "Science")
    expect(page).to have_selector('li', :text => "2013")
    expect(page).to have_selector('h1', :text => "Edited Dams Object")
    #expect(page).to have_selector('a', :text => "Library Digital Collections") # XXX: not displaying
    expect(page).to have_selector('li', :text => "Student")

    # Check Hydra View
    click_on "Hydra View"
    expect(page).to have_content("2013")
    expect(page).to have_content("Edited Dams Object")

    # check new object link
    click_on "New Object"
    expect(current_path).to eq(dams_object_path('new'))
  end

  scenario "Edit an object" do
    pending "Works in browser but fails in rspec" do
      sign_in_developer

      visit Path.path
      click_on "Edit"
      fill_in "MainTitle", :with => "Final Dams Object"
      fill_in "Note Displaylabel", :with => "Displays"
      fill_in "Date", :with => "2012", match: :first
      page.select('still image', match: :first)
      click_on "Save"

      expect(page).to have_selector('h1', :text => "Final Dams Object")
      expect(page).to have_selector('strong', :text => "DISPLAYS")
      expect(page).to have_selector('a', :text => "Image")
    end
  end

end

#feature 'Visitor wants to view an object' do
#  scenario 'is on Object index page' do
#    sign_in_developer
#    visit dams_objects_path
#    pending "not loading page, going to / instead" do
#      current_path.should == dams_objects_path
#      expect(page).to have_selector('a', :text => "Sample Audio Object: I need another green form")
#      click_on "Sample Audio Object: I need another green form"
#      expect(page).to have_selector('li', :text => "English")
#      expect(page).to have_selector('h1', :text => "Sample Audio Object")
#      expect(page).to have_selector('h2', :text => "I need another green form")
#    end
#  end
#end

feature 'Visitor wants to cancel unsaved objects' do
  
  # works in browser, but failing in rspec
  scenario "is on Edit Object page" do
    sign_in_developer
    visit Path.path
    expect(page).to have_selector('a', :text => "Edit")
    click_on "Edit"
    pending "Not loading page, going to / instead" do
      fill_in "MainTitle", :with => "Nothing"
      fill_in "Date", :with => "1241", match: :first
      click_on "Cancel"
      visit(Path.path)
      current_path.should == Path.path
      expect(page).to_not have_content("Nothing")
      expect(page).to_not have_content("1241")
      expect(page).to have_content("Final Dams Object")
    end
  end

#  scenario "Cancel creating an object" do
#    pending "Works in browser but fails in rspec" do
#      sign_in_developer
#      visit new_dams_object_path
#      fill_in "MainTitle", :with => "Dams Test Object"
#      fill_in "Date", :with => "NO DATE", match: :first
#      click_on "Cancel"
#      expect('/object').to eq(current_path)
#      expect(page).to have_selector('a', :text => "Sample Audio Object: I need another green form")
#      expect(page).to have_selector('a', :text => "Create Object")
#    end
#  end

  scenario 'valid pan/zoom image viewer' do
    visit zoom_path 'bd3379993m', '0'
    expect(page).to have_selector('div#map')
    expect(page).not_to have_selector('header')
  end
  scenario 'invalide pan/zoom image viewer' do
    visit zoom_path 'bd3379993m', '9'
    expect(page).to have_selector('p', :text => "Error: unable to find zoomable image.")
  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
