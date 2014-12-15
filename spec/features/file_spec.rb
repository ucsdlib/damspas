require 'spec_helper'
require 'cancan'


# create a single (public) test record
@obj = DamsObject.new
@obj.attributes = {titleValue:"File Upload Test", copyrightURI: "bd0513099p"}
@obj.save
test_pid = @obj.pid

feature "Access control enforcement" do
  scenario "Anonymous should be able to access public object files" do
    visit file_path( 'bd22194583', '_4.jpg' )
    expect(page.driver.response.status).to eq( 200 )
  end
  scenario "Anonymous shouldn't be able to access restricted object files" do
    visit file_path( 'bd0922518w', '_4_4.jpg' )
    expect(page).to have_selector('h1', :text => 'Forbidden')
  end
  scenario "Curators should be able to access restricted object files" do
    sign_in_developer
    visit file_path( 'bd0922518w', '_4_4.jpg' )
    expect(page.driver.response.status).to eq( 200 )
  end
end

feature "Derivative download" do 
  scenario 'is on the view page for single image object' do
    visit catalog_index_path( {:q => 'sample'} )
    click_link "Sample Image Component"
    expect(page).to have_link('', href:"/object/bd3379993m/_2.jpg/download")
  end
  scenario 'is on the view page for single audio object and the download link is disabled' do
    visit catalog_index_path( {:q => 'sample'} )
    click_link "The Sample Audio Object: I need another green form"
    expect(page).not_to have_link('', href:"/object/bd5939745h/_2.mp3/download")
  end  
end
