require 'spec_helper'

# Class to store the path of the object
class Path
  class << self
    attr_accessor :path
  end
  # Variable to be used to store DAMS Object path
  # Used for editing specified object
  @path = nil
end


feature 'Visitor wants to create/edit a MADS Complex Subject' do
    let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
    let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }

    after do
        scheme1.destroy
        scheme2.destroy
    end
  scenario 'is on Complex Subject index page' do
    sign_in_developer

    visit mads_complex_subjects_path
    click_on "Create Complex Subject"
    # Create new object

    fill_in "Name", :with => "Test Complex Subject"
    fill_in "ExternalAuthority", :with => "http://complexsubject.com"
    fill_in "Topic", :with => "Test Topic"
    fill_in "Temporal", :with => "Test Temporal"
    fill_in "GenreForm", :with => "Test GenreForm"
    fill_in "Geographic", :with => "Test Geographic"
    fill_in "Occupation", :with => "Test Occupation"
    fill_in "PersonalName", :with => "Test PersonalName"
    fill_in "ConferenceName", :with => "Test ConferenceName"
    fill_in "CorporateName", :with => "Test CorporateName"
    fill_in "FamilyName", :with => "Test FamilyName"
    fill_in "mads_complex_subject_genericName_attributes_0_name", :with => "Test Generic Name"
    page.select("Library of Congress Name Authority File", match: :first)


    click_on "Save"

    # Save path of object for other test(s)
    Path.path = current_path
    expect(page).to have_selector('strong', :text => "Test Complex Subject")
    expect(page).to have_selector('li', :text => "Test Topic")
    expect(page).to have_selector('li', :text => "Test Temporal")
    expect(page).to have_selector('li', :text => "Test GenreForm")
    expect(page).to have_selector('li', :text => "Test Geographic")
    expect(page).to have_selector('li', :text => "Test Occupation")
    expect(page).to have_selector('li', :text => "Test PersonalName")
    expect(page).to have_selector('li', :text => "Test ConferenceName")
    expect(page).to have_selector('li', :text => "Test CorporateName")
    expect(page).to have_selector('li', :text => "Test FamilyName")
    expect(page).to have_selector('li', :text => "Test Generic Name")
    expect(page).to have_selector('a', :text => "http://complexsubject.com")
    expect(page).to have_selector('li', :text => "Library of Congress Name Authority File")
    #expect(page).to have_selector('a', :text => "http://library.ucsd.edu/ark:/20775/bd0683587d")

    click_on "Edit"


    fill_in "Name", :with => ""
    fill_in "ExternalAuthority", :with => ""
    fill_in "Topic", :with => ""
    fill_in "Temporal", :with => ""
    fill_in "GenreForm", :with => ""
    fill_in "Geographic", :with => ""
    fill_in "Occupation", :with => ""
    fill_in "PersonalName", :with => ""
    fill_in "ConferenceName", :with => ""
    fill_in "CorporateName", :with => ""
    fill_in "FamilyName", :with => ""
    fill_in "mads_complex_subject_genericName_attributes_0_name", :with => ""


    click_on "Save"

    expect(page).to_not have_selector('li', :text => "Test")

  end

  scenario 'is on the Complex Subject page to be edited' do
    sign_in_developer

    visit Path.path
    click_on "Edit"
    fill_in "Name", :with => "Test Complex Subject"
    fill_in "ExternalAuthority", :with => "http://complexsubject.com"
    fill_in "Topic", :with => "Test Topic"
    fill_in "Temporal", :with => "Test Temporal"
    fill_in "GenreForm", :with => "Test GenreForm"
    fill_in "Geographic", :with => "Test Geographic"
    fill_in "Occupation", :with => "Test Occupation"
    fill_in "PersonalName", :with => "Test PersonalName"
    fill_in "ConferenceName", :with => "Test ConferenceName"
    fill_in "CorporateName", :with => "Test CorporateName"
    fill_in "FamilyName", :with => "Test FamilyName"
    fill_in "mads_complex_subject_genericName_attributes_0_name", :with => "Test Generic Name"
    page.select("Library of Congress Subject Headings", match: :first)

    click_on "Save"

    expect(page).to have_selector('strong', :text => "Test Complex Subject")
    expect(page).to have_selector('li', :text => "Test Topic")
    expect(page).to have_selector('li', :text => "Test Temporal")
    expect(page).to have_selector('li', :text => "Test GenreForm")
    expect(page).to have_selector('li', :text => "Test Geographic")
    expect(page).to have_selector('li', :text => "Test Occupation")
    expect(page).to have_selector('li', :text => "Test PersonalName")
    expect(page).to have_selector('li', :text => "Test ConferenceName")
    expect(page).to have_selector('li', :text => "Test CorporateName")
    expect(page).to have_selector('li', :text => "Test FamilyName")
    expect(page).to have_selector('li', :text => "Test Generic Name")
    expect(page).to have_selector('a', :text => "http://complexsubject.com")
    expect(page).to have_selector('li', :text => "Library of Congress Subject Headings")
  end



end

feature 'Visitor wants to cancel unsaved objects' do
    let!(:scheme1) { MadsScheme.create!(name: 'Library of Congress Subject Headings') }
    let!(:scheme2) { MadsScheme.create!(name: 'Library of Congress Name Authority File') }

    after do
        scheme1.destroy
        scheme2.destroy
    end
  scenario 'is on Edit Complex Subject page' do
    sign_in_developer
    visit Path.path
    expect(page).to have_selector('a', :text => "Edit")
    click_on "Edit"
    fill_in "Name", :with => "Nothing"
    fill_in "Topic", :with => "Null", match: :first
    page.select("Library of Congress Name Authority File", match: :first)
    click_on "Cancel"
    expect(page).to_not have_content("Should not show")
    expect(page).to have_content("Test Complex Subject")
    expect(page).to_not have_content("Library of Congress Name Authority File")

  end

  scenario 'is on Create Complex Subject page' do
    sign_in_developer
    visit mads_complex_subjects_path
    click_on "Create Complex Subject"
    fill_in "Name", :with => "BROKEN"
    fill_in "GenreForm", :with => "NONE"
    click_on "Cancel"
    expect(current_path).to eq(mads_complex_subjects_path)
  end

end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
