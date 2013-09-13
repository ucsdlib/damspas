require 'spec_helper'
require 'cancan'


# create a single (public) test record
@obj = DamsObject.new
@obj.attributes = {titleValue:"File Upload Test", copyrightURI: "bd0513099p"}
@obj.save
pid = @obj.pid

# reindex to make sure rights are index correctly
solrizer = Solrizer::Fedora::Solrizer.new
solrizer.solrize pid

feature "Anonymous user shouldn't be able to upload files" do
  scenario "Link to Hydra view should be hidden" do
    visit dams_object_path(pid)
    expect(page).not_to have_selector('a', :text => 'Hydra View')
  end

  scenario "Shouldn't be able to access Hydra view" do
    expect { visit view_dams_object_path(pid) }.to raise_error(
      CanCan::AccessDenied)
  end

  scenario "Shouldn't be able to upload file" do
    expect { page.driver.post upload_path(pid) }.to raise_error(
      CanCan::AccessDenied)
  end
end

feature "Curator should be able to upload files" do
  scenario "Link to Hydra view should be shown" do
    sign_in_developer
    visit dams_object_path(pid)
    expect(page).to have_selector('a', :text => 'Hydra View')
  end
  scenario "Empty upload should return error" do
    sign_in_developer
    visit view_dams_object_path(pid)
    expect(page).to have_selector('h2', :text => 'Add File')
    click_on "Add File"
    expect(page).to have_selector('div', :text => 'No file upload found')
  end
  scenario "Uploading XML file" do
    sign_in_developer
    visit view_dams_object_path(pid)
    attach_file 'file', File.join(Rails.root,'/spec/fixtures/madsScheme.rdf.xml')
    click_on "Add File"
    expect(page).to have_selector('div', :text => 'File Uploaded')

    # make sure the file actually exists
    visit file_path( pid, '_1.xml' )
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
  scenario "Uploading JPG file and generating derivatives" do
    sign_in_developer
    visit view_dams_object_path(pid)
    attach_file 'file', File.join(Rails.root,'/app/assets/images/ucsd/bg.jpg')
    click_on "Add File"
    expect(page).to have_selector('div', :text => 'File Uploaded')
    expect(page).to have_button('Generate Derivatives')

    # generate derivatives
    click_on 'Generate Derivatives'
    expect(page).to have_selector('div', :text => 'Derivatives created successfully')

    # make sure file exists
    visit file_path( pid, '_1.jpg' )
    response = page.driver.response
    expect(response.status).to eq( 200 )

    # make sure derivative exists
    visit file_path( pid, '_2.jpg' )
    response = page.driver.response
    expect(response.status).to eq( 200 )
  end
end

feature "Access control enforcement" do
  scenario "Anonymous should be able to access public object files" do
    visit file_path( 'bd22194583', '_4.jpg' )
    expect(page.driver.response.status).to eq( 200 )
  end
  scenario "Anonymous shouldn't be able to access restricted object files" do
    expect { visit file_path( 'bd0922518w', '_4_4.jpg' ) }.to raise_error(
      CanCan::AccessDenied)
  end
  scenario "Curators should be able to access restricted object files" do
    sign_in_developer
    visit file_path( 'bd0922518w', '_4_4.jpg' )
    expect(page.driver.response.status).to eq( 200 )
  end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "name", :with => "name"
  fill_in "email", :with => "email@email.com"
  click_on "Sign In"
end
