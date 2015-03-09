require 'spec_helper'
require 'cancan'

feature "Access control enforcement" do
  pending "working object metadata creation" do
    # create a single (public) test record
    before(:all) do
      @copy = DamsCopyright.new status: 'Public domain'
      @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
      @publicObj = DamsObject.new pid: 'xx1234567x', titleValue:"Public File Test", copyright_attributes: [{status: 'Public domain'}], file_attributes: [{ id: '3.txt', use: 'image-source' }], unitURI: @unit.pid
      @publicObj.add_file( "dummy file content", "_3.txt", "test.txt" )
      @publicObj.save
      solr_index @publicObj.pid

      @curatorObj = DamsObject.create titleValue:"Curator File Test", file_attributes: [{ id: '3.txt', use: 'image-source' }]
      solr_index @curatorObj.pid
    end
    after(:all) do
      @publicObj.delete
      @curatorObj.delete
      @copy.delete
    end
    scenario "Anonymous should be able to access public object files" do
      visit file_path( @publicObj, '_3.txt' )
      expect(page.driver.response.status).to eq( 200 )
    end
    scenario "Anonymous shouldn't be able to access restricted object files" do
      visit file_path( @curatorObj, '_3.txt' )
      expect(page).to have_selector('h1', :text => 'Forbidden')
    end
    scenario "Curators should be able to access restricted object files" do
      sign_in_developer
      visit file_path( @curatorObj, '_3.txt' )
      expect(page.driver.response.status).to eq( 200 )
    end
  end
end

feature "Derivative download" do 
  pending "working object metadata creation" do
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
end

describe "Download more than one master file" do
  before do
    @damsNewspaperObj = DamsObject.new(pid: "xx21171293")
  end
  after do
    @damsNewspaperObj.delete
  end
  it "should see two buttons to download two master files" do
    pending "working object metadata creation" do
      @damsNewspaperObj.damsMetadata.content = File.new('spec/fixtures/damsObjectNewspaper.rdf.xml').read
      @damsNewspaperObj.save!
      solr_index (@damsNewspaperObj.pid)   
      visit dams_object_path(@damsNewspaperObj.pid)
      expect(page).to have_link('', href:"/object/xx21171293/_1.pdf/download")
      expect(page).to have_link('', href:"/object/xx21171293/_2.tgz/download")
    end
  end
end
