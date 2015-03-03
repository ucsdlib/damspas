require 'spec_helper'

feature 'Visitor wants to look at collections' do
  before do
    @part = DamsProvenanceCollectionPart.create titleValue: "Sample Provenance Part", visibility: "public"
    @prov = DamsProvenanceCollection.create titleValue: "Sample Provenance Collection", provenanceCollectionPartURI: @part.pid, visibility: "public"
    @assm = DamsAssembledCollection.create titleValue: "Sample Assembled Collection", visibility: "public"
    @priv = DamsProvenanceCollection.create titleValue: "curator-only collection", visibility: "curator"

    solr_index @prov.pid
    solr_index @assm.pid
    solr_index @part.pid
    solr_index @priv.pid

    @copy = DamsCopyright.create status: 'Public domain'
    @provObj = DamsObject.create titleValue: 'Test Object in Provenance Collection', provenanceCollectionURI: @prov.pid, copyrightURI: @copy.pid
    @partObj = DamsObject.create titleValue: 'Test Object in Provenance Part', provenanceCollectionURI: @part.pid, copyrightURI: @copy.pid
    solr_index @partObj.pid
    solr_index @provObj.pid
  end
  after do
    @partObj.delete
    @provObj.delete
    @copy.delete
    @assm.delete
    @prov.delete
    @part.delete
    @priv.delete
  end
  scenario 'public collections list' do
    visit catalog_facet_path('collection_sim')
    expect(page).not_to have_selector('a', :text => 'curator-only collection')
  end
  scenario 'curator collections list' do
    sign_in_developer
    visit dams_collections_path({:per_page=>100})
    expect(page).to have_selector('a', :text => 'curator-only collection')
  end
  scenario 'recursive collection membership' do
    sign_in_developer
    visit catalog_index_path({'f[collection_sim][]' => 'Sample Provenance Collection'})
    expect(page).to have_selector('a', :text => 'Test Object in Provenance Collection')
    expect(page).to have_selector('a', :text => 'Test Object in Provenance Part')
  end

  scenario 'collections search without query' do
    visit dams_collections_path
    expect(page).to have_selector('a', :text => 'Sample Assembled Collection')
    expect(page).to have_selector('a', :text => 'Sample Provenance Collection')
  end
  scenario 'collections search with query' do
    visit dams_collections_path( {:q => 'assembled'} )
    expect(page).to have_selector('a', :text => 'Sample Assembled Collection')
    expect(page).not_to have_selector('a', :text => 'Sample Provenance Collection')
  end
  scenario 'curator view' do
    sign_in_developer
    visit dams_collection_path @prov.pid # santa fe light cone
    expect(page).to have_link('RDF View')
  end
  scenario 'damsProvenanceCollectionPart view with parent collection name' do
    visit dams_collection_path @part.pid
    expect(page).to have_link('Sample Provenance Collection') 
  end  
end
