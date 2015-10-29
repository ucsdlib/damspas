require 'spec_helper'

describe "keyword field" do
  it "should prefill the search term if the params exist" do
      visit '/advanced?q=fish'
      expect(page).to have_selector("input[value='fish']")
  end
end

describe "facet field" do
  before(:all) do
    @acol = DamsAssembledCollection.create( titleValue: 'Sample Assembled Collection',
              subtitle: 'Subtitle', titleNonSort: 'The', titlePartName: 'Allegro', titlePartNumber: '1',
              visibility: 'public' )
    @part = DamsProvenanceCollectionPart.create( titleValue: 'Sample Provenance Part',
              subtitle: 'Subtitle', titleNonSort: 'The', titlePartName: 'Allegro', titlePartNumber: '1',
              visibility: 'public' )
    @unit = DamsUnit.create( name: "Test Unit", description: "Test Description", code: "test", group: "dams-curator", uri: "http://example.com/")
    @copy = DamsCopyright.create( status: "Public domain")
    @obj = DamsObject.create( typeOfResource: 'still image', unitURI: @unit.pid, assembledCollectionURI: [ @acol.pid ], provenanceCollectionPartURI: [ @part.pid ], titleValue: 'Test', copyrightURI: @copy.pid)
    solr_index @obj.pid
  end
  after(:all) do
    @obj.delete
    @copy.delete
    @unit.delete
    @acol.delete
    @part.delete
  end
  it "should prefill the facet if the facet params exist" do
      visit '/advanced?f[unit_sim][]=Test+Unit&f[object_type_sim][]=image'
      expect(page).to have_selector("input[id='f_inclusive_object_type_sim_image'][checked='checked']")
      expect(page).to have_selector("input[id='f_inclusive_unit_sim_Test_Unit'][checked='checked']")
  end

  it "should not prefill the facet if the facet params does not exist" do
      visit '/advanced?q=fish'
      expect(page).not_to have_selector("input[checked='checked']")
  end

  it "should display all facets when previous page is browse by collection" do
     visit '/collections'
     click_link "Advanced Search"
     
     expect(page).to have_selector('h4', :text => 'Repository')
     expect(page).to have_selector('h4', :text => 'Collection')
     expect(page).to have_selector('h4', :text => 'Format')
  end
end

