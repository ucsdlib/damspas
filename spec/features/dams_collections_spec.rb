require 'spec_helper'

feature 'Visitor wants to look at collections' do
  before(:all) do
    @part = DamsProvenanceCollectionPart.create titleValue: "Sample Provenance Part", visibility: "public"
    @prov = DamsProvenanceCollection.create titleValue: "Sample Provenance Collection", provenanceCollectionPartURI: @part.pid, visibility: "public"
    @part.provenanceCollectionURI = @prov.pid
    @part.save
    @assm = DamsAssembledCollection.create titleValue: "Sample Assembled Collection", visibility: "public"
    @priv = DamsProvenanceCollection.create titleValue: "curator-only collection", visibility: "curator"

    solr_index @prov.pid
    solr_index @assm.pid
    solr_index @part.pid
    solr_index @priv.pid

    @copy = DamsCopyright.create status: 'Public domain'
    @partObj = DamsObject.create titleValue: 'Test Object in Provenance Part', provenanceCollectionPartURI: @part.pid, copyrightURI: @copy.pid
    @provObj = DamsObject.create titleValue: 'Test Object in Provenance Collection', provenanceCollectionURI: @prov.pid, copyrightURI: @copy.pid
    solr_index @partObj.pid
    solr_index @provObj.pid
  end
  after(:all) do
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

feature 'Visitor wants to look at the collection search results view with no issued date' do
  before do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @provCollection = DamsProvenanceCollection.create(pid: "uu8056206n", visibility: "public")
    @provCollection.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection3.rdf.xml').read
    @provCollection.save!
    solr_index (@provCollection.pid)   
  end
  after do
    @provCollection.delete
    @unit.delete
  end 
  scenario 'should see the collection result page with no issued date' do
    visit catalog_index_path( {:q => "#{@provCollection.pid}"} )
    expect(page).to have_selector('h3', :text => 'Heavy Metals in the Ocean Insect, Halobates')   
    expect(page).to have_selector("ul.dams-search-results-fields:first li span", :text => '1961-1978')
    expect(page).to have_no_content('1000-2015')     
  end

end

feature 'Visitor wants to see the collection record' do
  before do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @commonName = DamsCommonName.create pid: "xx000101ac", name:"thale-cress external"
    @provCollection = DamsProvenanceCollection.create(pid: "uu8056206n", visibility: "public")
    @provCollection.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection3.rdf.xml').read
    @provCollection.save!
    solr_index (@provCollection.pid)   
  end
  after do
    @provCollection.delete
    @unit.delete
    @commonName.delete
  end 
  scenario 'should see the related resource with no URI' do
    visit dams_collection_path("#{@provCollection.pid}")
    expect(page).to have_content('The physical materials are held at UC San Diego Library')
    expect(page).not_to have_link('The physical materials are held at UC San Diego Library', {href: ''})    
  end
  scenario 'should see the names in order' do
    visit dams_collection_path("#{@provCollection.pid}")
    expect(page).to have_selector("div.span8 dl dt[1]", :text => 'Principal Investigator')  
    expect(page).to have_selector("div.span8 dl dt[3]", :text => 'Co Principal Investigator')
    expect(page).to have_selector("div.span8 dl dt[5]", :text => 'Creator')
    expect(page).to have_selector("div.span8 dl dt[7]", :text => 'Author')
    expect(page).to have_selector("div.span8 dl dt[9]", :text => 'Contributors')
        
  end
  scenario 'should see the internal and external common names' do
    visit dams_collection_path("#{@provCollection.pid}")
    expect(page).to have_selector('li', text: 'thale-cress')
    expect(page).to have_selector('li', text: 'thale-cress external')
  end
end

feature 'COLLECTIONS IMAGES --' do

  before do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @commonName = DamsCommonName.create pid: "xx000101ac", name:"thale-cress external"
    @provCollection = DamsProvenanceCollection.create(pid: "uu8056206n", visibility: "public")
    @provCollection.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection3.rdf.xml').read
    @provCollection.save!
    solr_index (@provCollection.pid)
  end
  after do
    @provCollection.delete
    @unit.delete
    @commonName.delete
  end

  scenario 'PAGE SHOULD HAVE COLLECTION IMAGE CONTAINERS' do
    visit dams_collection_path("#{@provCollection.pid}")
    expect(page).to have_selector("#collections-masthead")
    expect(page).to have_selector("#collections-image")
  end

  scenario 'PAGE SHOULD HAVE COLLECTION IMAGE <IMG> ELEMENT IN DESKTOP VIEW' do
    visit dams_collection_path("#{@provCollection.pid}")
    expect(page).to have_selector("#collections-image img")
  end

end