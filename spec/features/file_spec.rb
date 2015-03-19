require 'spec_helper'
require 'cancan'


feature "Derivative download" do 
  before(:all) do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                code: "tu", uri: "http://example.com/"
    @obj1 = DamsObject.create( titleValue: 'JPEG Test', typeOfResource: 'image',
                unitURI: [ @unit.pid ], copyright_attributes: [{status: 'Public domain'}] )
    jpeg_content = '/9j/4AAQSkZJRgABAQEAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/wAALCAABAAEBAREA/8QAFAABAAAAAAAAAAAAAAAAAAAACf/EABQQAQAAAAAAAAAAAAAAAAAAAAD/2gAIAQEAAD8AVN//2Q=='
    @obj1.add_file( Base64.decode64(jpeg_content), "_1.jpg", "test.jpg" )
    @obj1.save

    @obj2 = DamsObject.create( titleValue: 'MP3 Test', typeOfResource: 'sound recording',
                unitURI: [ @unit.pid ], copyright_attributes: [{status: 'Public domain'}] )
    mp3_content = "//tQxAAAAAAAAAAAAAAAAAAAAAAASW5mbwAAAA8AAAACAAACcQCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA//////////////////////////////////////////////////////////////////8AAAA5TEFNRTMuOTlyAaUAAAAALf4AABRAJAaWQgAAQAAAAnEy8lFkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/7UMQAAAdsJSBAmMBBKIbj2JSY0QAEoeCBAABBBDYMIECBAhDwQBAMQQdSGP5QHwfB/98Tg+DgIAgCDvBx38oc/lAQd+jkAf//AgIO6wfD4mkEpBZEiRSshCoVCwJBoEiZpyIBJEiVeSJEiFPxdBBQUF/+BQUEgvhQV4UFBQSCgoKChX9BTf/+RQUFN/8QUF/8QU34oKC/0FBVTEFNRTMuOTkuNVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/+1LEGoPAAAGkAAAAIAAANIAAAARVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVQ=="
    @obj2.add_file( Base64.decode64(mp3_content), "_1.mp3", "test.mp3" )
    @obj2.save

    @obj3 = DamsObject.create( titleValue: 'TXT Test', typeOfResource: 'text', unitURI: [@unit.pid],
                copyright_attributes: [{status: 'Under copyright'}] )
    @obj3.add_file( "dummy text content", "_1.txt", "test.txt" )
    @obj3.save

    solr_index @obj1.pid
    solr_index @obj2.pid
    solr_index @obj3.pid
  end
  after(:all) do
    @obj1.delete
    @obj2.delete
    @obj3.delete
    @unit.delete
  end
  scenario 'anonymous user should be able to view and download image file' do
    visit dams_object_path @obj1
    expect(page).to have_selector('h1', text: 'JPEG Test')
    expect(page).to have_link('', href:"/object/#{@obj1.pid}/_1.jpg/download")

    visit file_path( @obj1, '_1.jpg' )
    expect(page.driver.response.status).to eq( 200 )
    expect(response_headers['Content-Type']).to include 'image/jpeg'
  end
  scenario 'curator should see download link for image file' do
    sign_in_developer
    visit dams_object_path @obj1
    expect(page).to have_selector('h1', text: 'JPEG Test')
    expect(page).to have_link('', href:"/object/#{@obj1.pid}/_1.jpg/download")
  end
  scenario 'anonymous should not see download link for audio file' do
    visit dams_object_path @obj2
    expect(page).to have_selector('h1', text: 'MP3 Test')
    expect(page).not_to have_link('', href:"/object/#{@obj2.pid}/_1.mp3/download")
  end
  scenario 'curator should see download link for audio file' do
    sign_in_developer
    visit dams_object_path @obj2
    expect(page).to have_selector('h1', text: 'MP3 Test')
    expect(page).to have_link('', href:"/object/#{@obj2.pid}/_1.mp3/download")
  end
  scenario "Anonymous shouldn't be able to access restricted object files" do
    visit file_path( @obj3, '_1.txt' )
    expect(page).to have_selector('h1', :text => 'Forbidden')
  end
  scenario "Curators should be able to access restricted object files" do
    sign_in_developer
    visit file_path( @obj3, '_1.txt' )
    expect(page.driver.response.status).to eq( 200 )
  end
end

describe "Download more than one master file" do
  before do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                code: "tu", uri: "http://example.com/"
    @newspaper = DamsObject.create(pid: "xx21171293")
    @newspaper.damsMetadata.content = File.new('spec/fixtures/damsObjectNewspaper.rdf.xml').read
    @newspaper.save!
    solr_index (@newspaper.pid)   
  end
  after do
    @newspaper.delete
  end
  it "should see two buttons to download two master files" do
    visit dams_object_path(@newspaper.pid)
    expect(page).to have_link('', href:"/object/xx21171293/_1.pdf/download")
    expect(page).to have_link('', href:"/object/xx21171293/_2.tgz/download")
  end
end
