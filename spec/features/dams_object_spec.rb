require 'spec_helper'
require 'rack/test'

# Class to store the path of the object
class Path
  class << self
    attr_accessor :path
  end
  # Variable to be used to store DAMS Object path
  # Used for editing specified object
  # @path = nil
end

feature 'Visitor want to look at objects' do

  scenario 'view a sample object record' do
    pending "working object metadata updates"
    sign_in_developer
    visit dams_object_path('bd0922518w')
    Path.path = current_path
    expect(page).to have_selector('h1',:text=>'Sample Complex Object Record #3')
    expect(page).to have_selector('h2',:text=>'Format Sampler')
    #expect(page).to have_link('http://library.ucsd.edu/ark:/20775/bd0922518w', href: 'http://library.ucsd.edu/ark:/20775/bd0922518w')

    # admin links
    expect(page).to have_link('RDF View')
  end

  scenario 'view full title with non filing characters' do
    pending "working object metadata updates"
    visit dams_object_path('bd22194583')
    expect(page).to have_selector('h1',:text=>'The Sample Simple Object')
    expect(page).to have_selector('h2',:text=>'An Image Object, Allegro 1')
  end

  scenario 'view a sample object record with subtitle, part, and a translation variant title' do
    pending "working object metadata updates"
    ark = 'zz55555555'
    sign_in_developer
    # Create a sample object with subtitle and variant titles
    damsObj = DamsObject.new(pid: ark)
 	damsObj.damsMetadata.content = File.new('spec/fixtures/titleTest.xml').read
    damsObj.save!
    solr_index ark

    visit dams_object_path(ark)
    expect(page).to have_selector('h2', :text => 'Name/Note/Subject Sampler, sample partname sample partnumber, Translation Variant')
    expect(page).to have_link('RDF View', rdf_dams_object_path(ark))
    expect(page).to have_link('Data View', data_dams_object_path(ark))
    expect(page).to have_link('DAMS 4.2 Preview', dams42_dams_object_path(ark))

    # Delete the sample object after test
    damsObj.delete
  end  
  
  scenario "review metadata of an object" do
    pending "working object metadata updates"
    sign_in_developer
    visit dams_object_path('bd0922518w')
    click_on "Data View"
    expect(page).to have_selector('td', :text => "Object")
    expect(page).to have_selector('td', :text => "http://library.ucsd.edu/ark:/20775/bd0922518w")
  end

  scenario "view RDF/XML of an object" do
    pending "working object metadata updates"
    sign_in_developer
    visit dams_object_path('bd0922518w')
    click_on "RDF View"
    expect(page.status_code).to eq 200
    expect(response_headers['Content-Type']).to include 'application/xml'
  end

  pending "Enabled once damsrepo enable RDF Turtle format: view RDF Turtle of an object" do
    sign_in_developer
    visit dams_object_path('bd0922518w')
    click_on "RDF Turtle View"
    expect(page.status_code).to eq 200
    expect(response_headers['Content-Type']).to include 'text'
    expect(page).to have_content("@prefix");
  end

  scenario "view RDF N-Triples of an object" do
    pending "working object metadata updates"
    sign_in_developer
    visit dams_object_path('bd0922518w')
    click_on "RDF N-Triples View"
    expect(page.status_code).to eq 200
    expect(response_headers['Content-Type']).to include 'text'
    expect(page).to have_content("\" .");
  end

  scenario "view DAMS 4.2 RDF/XML of an object" do
    pending "working object metadata updates"
    sign_in_developer
    visit dams_object_path('bd0922518w')
    click_on "DAMS 4.2 Preview"
    expect(page.status_code).to eq 200
    expect(response_headers['Content-Type']).to include 'application/xml'
  end

  scenario 'view a sample data file' do
    pending "working object metadata updates"
    sign_in_developer
    visit file_path('bd0922518w','_5_5.jpg')
    response = page.driver.response
    expect(response.status).to eq( 200 )
    expect(response.header["Content-Type"]).to eq( "image/jpeg" )
  end
  
  scenario 'view a sample public html content file' do
    pending "working object metadata updates"
    visit file_path('bb01010101','_2_2.html')
    response = page.driver.response
    expect(response.status).to eq( 200 )
    expect(response.header["Content-Type"]).to have_content( "text/html" )
    expect(page).to have_link('MP3 Audio File', href: '/ark:/20775/bb07178662/1-2.mp3&name=ghio_sdhsoh.mp3')
  end

  scenario 'view a non-existent record' do
    visit dams_object_path('xxx')
    expect(page).to have_content 'You are not allowed to view this page.'
  end

  scenario 'view a file from a non-existing object' do
    visit file_path('xxx','xxx')
    expect(page).to have_content "The page you were looking for does not exist."
  end

  scenario 'view a non-existing file from an existing object' do
    visit file_path('bd0922518w','xxx')
    expect(page).to have_content "The page you were looking for does not exist."
  end

end


feature 'Visitor wants to look at pan/zoom image viewer' do

  scenario 'valid pan/zoom image viewer' do
    pending "working object metadata updates"
    visit zoom_path 'bd3379993m', '0'
    expect(page).to have_selector('div#map')
    expect(page).not_to have_selector('header')
  end
  scenario 'invalide pan/zoom image viewer' do
    pending "working object metadata updates"
    visit zoom_path 'bd3379993m', '9'
    expect(page).to have_selector('p', :text => "Error: unable to find zoomable image.")
  end

end

feature 'Visitor wants to click the results link to go back to the search results' do
  
  scenario "is on the main page" do
    pending "working object metadata updates"
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('div.pagination-note', :text => "Results 1 - 8 of 8")
    expect(page).to have_selector('span.dams-filter', :text => "sample")    
    click_link "Sample Image Component"
    
    expect(page).to have_selector('div.search-results-pager', :text => "1 of 8 results Next")

    expect(page).to have_link('results', href:"http://www.example.com/search?q=sample")
    
  end
end

feature 'Visitor wants to click the direct object link when the referrer is not a search' do
  
  scenario "is on the main page" do
    pending "working object metadata updates"
    visit catalog_index_path( {:q => 'sample'} )
    click_link "Sample Image Component"   
    expect(page).to have_selector('div.search-results-pager', :text => "1 of 8 results Next")

    #visit another object view page
    visit dams_object_path(:id => 'bd22194583')
    expect(page).to have_selector('h1', :text => "Sample Simple Object")
    expect(page).not_to have_selector('div.search-results-pager', :text => "1 of 8 results Next")
  end
end

feature 'Visitor wants to click the object link and does not want to see the counter parameter in the url' do
  
  scenario "is on the main page" do
    visit catalog_index_path( {:q => 'sample'} )
    click_link "Sample Image Component"
    URI.parse(current_url).request_uri.should == "/object/bd3379993m"
  end
end

feature 'Format link(s) need to be scoped to the collection level ' do
  
  scenario "is on the object view page" do
    pending "working object metadata updates"
    visit dams_object_path(:id => 'bd3379993m')
    expect(page).to have_link('image')

    click_link "image"
    expect(page).to have_selector('span.dams-filter a', :text => "UCSD Electronic Theses and Diss…")
    expect(page).to have_selector('span.dams-filter a', :text => "image")
    
  end
end

describe "complex object view" do
  before(:all) do
    @damsComplexObj = DamsObject.create(pid: "xx97626129")
  end
  after(:all) do
    @damsComplexObj.delete
  end
  it "should see the component hierarchy view" do
    pending "working object metadata updates"
    @damsComplexObj.damsMetadata.content = File.new('spec/fixtures/damsComplexObject3.rdf.xml').read
    @damsComplexObj.save!
    solr_index (@damsComplexObj.pid)
    visit dams_object_path(@damsComplexObj.pid)
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Interval 1 (dredge, rock)')
    expect(page).to have_selector('button#node-btn-1',:text => 'Interval 1 (dredge, rock)')
    expect(page).to have_selector('button#node-btn-2',:text => 'Files')
    
    #click on grand child link
    click_on 'Image 001'
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Image 001')
        
    #return to the top level record
    click_on 'Components of "PPTU04WT-027D (dredge, rock)"'
    expect(page).to have_selector('h1:first',:text=>'PPTU04WT-027D (dredge, rock)')
    expect(page).to have_selector('h1[1]',:text=>'Interval 1 (dredge, rock)')         
  end     
end

describe "to look at a simple SIO object" do
  before(:all) do
    @damsSioObj = DamsObject.create(pid: "xx3243380c")
  end
  after(:all) do
    @damsSioObj.delete
  end
  it "should not see the accession number in public view" do
    pending "working object metadata updates"
    @damsSioObj.damsMetadata.content = File.new('spec/fixtures/damsSioObject.rdf.xml').read
    @damsSioObj.save!
    solr_index (@damsSioObj.pid)   
    visit dams_object_path(@damsSioObj.pid)
    expect(page).not_to have_selector('span.dams-note-display-label:first',:text=>'Accession Number')                 
  end
  
   it "should see the accession number in curator view" do
    pending "working object metadata updates"
    @damsSioObj.damsMetadata.content = File.new('spec/fixtures/damsSioObject.rdf.xml').read
    @damsSioObj.save!
    solr_index (@damsSioObj.pid)    
    sign_in_developer       
    visit dams_object_path(@damsSioObj.pid)
    expect(page).to have_selector('span.dams-note-display-label',:text=>'Accession Number')
   end     
end
