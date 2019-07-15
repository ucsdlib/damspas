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
    sign_in_anonymous '132.239.0.3'
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
    expect(page).to have_link('', href:"/object/#{@obj1.pid}/_1.jpg/download?access=curator")
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
    expect(page).to have_link('', href:"/object/#{@obj2.pid}/_1.mp3/download?access=curator")
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
  scenario "should see volume-up icon when searching for audio file" do
    visit catalog_index_path( {:q => @obj2.id} )
    expect(page).to have_selector('a', :text => 'MP3 Test')
    expect(page).to have_css('i.glyphicon-volume-up')
  end
  scenario 'should have rel=nofollow for the download link' do
    sign_in_developer
    visit dams_object_path @obj2
    expect(page).to have_css('a[title="Download file"][rel="nofollow"]')
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
  it "should see one download button in public view and two download buttons in curator view" do
    visit dams_object_path(@newspaper.pid)
    expect(page).to have_link('', href:"/object/xx21171293/_1.pdf/download")
    expect(page).to_not have_link('', href:"/object/xx21171293/_2.tgz/download")

    sign_in_developer
    visit dams_object_path(@newspaper.pid)
    expect(page).to have_link('', href:"/object/xx21171293/_1.pdf/download?access=curator")
    expect(page).to have_link('', href:"/object/xx21171293/_2.tgz/download?access=curator")
  end
end

describe "Download file in complex object" do
  before do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                code: "tu", uri: "http://example.com/"
    @complexObj = DamsObject.create( titleValue: 'JPEG Test', typeOfResource: 'image',
                  unitURI: [ @unit.pid ], copyright_attributes: [{status: 'Public domain'}] )
    jpeg_content = '/9j/4AAQSkZJRgABAQEAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/wAALCAABAAEBAREA/8QAFAABAAAAAAAAAAAAAAAAAAAACf/EABQQAQAAAAAAAAAAAAAAAAAAAAD/2gAIAQEAAD8AVN//2Q=='
    @complexObj.add_file( Base64.decode64(jpeg_content), "_1_2.jpg", "test.jpg" )
    @complexObj.save
    solr_index @complexObj.pid
  end
  after do
    @complexObj.delete
  end
  it "should show a download button" do
    sign_in_developer
    visit dams_object_path @complexObj.pid
    expect(page).to have_link('', href:"/object/#{@complexObj.pid}/_1_2.jpg/download?access=curator")
  end
end

describe "Download PDF file and second file with use value ends with '-source' for complex object" do
  before do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                code: "tu", uri: "http://example.com/"
    @complexObjPdf = DamsObject.create( titleValue: 'PDF ZIP Test', typeOfResource: 'document',
                  unitURI: [ @unit.pid ], copyright_attributes: [{status: 'Public domain'}] )
    @complexObjPdf.add_file( 'dummy pdf content', '_1_1.pdf', 'test.pdf' )
    @complexObjPdf.add_file( 'dummy mov content', '_1_2.mov', 'test.mov')
    @complexObjPdf.save!
    solr_index @complexObjPdf.pid
  end
  after do
    @complexObjPdf.delete
    @unit.delete
  end
  it "should show two download links" do
    sign_in_developer
    visit dams_object_path @complexObjPdf.pid
    expect(page).to have_link('', href:"/object/#{@complexObjPdf.pid}/_1_1.pdf/download?access=curator")
    expect(page).to have_link('', href:"/object/#{@complexObjPdf.pid}/_1_2.mov/download?access=curator")
  end
end
