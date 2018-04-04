require 'spec_helper'

feature 'Visitor wants to look at collections' do
  before(:all) do
    @part = DamsProvenanceCollectionPart.create titleValue: "Sample Provenance Part", visibility: "public"
    @prov = DamsProvenanceCollection.create titleValue: "Sample Provenance Collection", provenanceCollectionPartURI: @part.pid, visibility: "public"
    @part.provenanceCollectionURI = @prov.pid
    @part.save
    @assm = DamsAssembledCollection.create titleValue: "Sample('s): Assembled Collection", visibility: "public"
    @priv = DamsProvenanceCollection.create titleValue: "curator-only collection", visibility: "curator"

    solr_index @prov.pid
    solr_index @assm.pid
    solr_index @part.pid
    solr_index @priv.pid

    @copy = DamsCopyright.create status: 'Public domain'
    @partObj = DamsObject.create titleValue: 'Test Object in Provenance Part', provenanceCollectionPartURI: [@part.pid], assembledCollectionURI: [@assm.pid], copyrightURI: @copy.pid
    @provObj = DamsObject.create titleValue: 'Test Object in Provenance Collection', provenanceCollectionURI: @prov.pid, copyrightURI: @copy.pid
    @privObj = DamsObject.create titleValue: 'Test Object in curator-only collection', provenanceCollectionURI: @priv.pid, copyrightURI: @copy.pid
    solr_index @partObj.pid
    solr_index @provObj.pid
    solr_index @privObj.pid
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
    expect(page).to have_selector('a', :text => "Sample('s): Assembled Collection")
    expect(page).to have_selector('a', :text => 'Sample Provenance Collection')
  end
  scenario 'collections search with query' do
    visit dams_collections_path( {:q => 'assembled'} )
    expect(page).to have_selector('a', :text => "Sample('s): Assembled Collection")
    expect(page).not_to have_selector('a', :text => 'Sample Provenance Collection')
  end
  scenario 'curator view' do
    sign_in_developer
    visit dams_collection_path @prov.pid # santa fe light cone
    expect(page).to have_link('RDF View')
  end
  scenario 'damsProvenanceCollectionPart view with parent collection name and collection from faceting' do
    sign_in_developer
    visit dams_collection_path @part.pid
    expect(page).to have_link('Sample Provenance Collection') 
    expect(page).to have_link("Sample('s): Assembled Collection")
    expect(page).not_to have_link('Sample Provenance Part', :href => "#{dams_collection_path @part.pid}" )
    expect(page).not_to have_link('curator-only collection')
  end
  scenario 'damsProvenanceCollection view with objects but no parent collection' do
    sign_in_developer
    visit dams_collection_path @priv.pid
    expect(page).to have_selector('h1', :text => 'curator-only collection')
    expect(page).not_to have_selector('dt', :text => 'Collections')
  end

  scenario 'search results and see access control information (curator)' do
    sign_in_developer
    visit dams_collections_path({:per_page=>100})
    expect(page).to have_content('Access: Curator Only')
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

  scenario 'should not see access control information (public)' do
    visit dams_collection_path("#{@provCollection.pid}")
    expect(page).to have_no_content('AccessPublic')
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

#---

feature 'Collection editor tools' do
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
  scenario "with anonymous access should not see the metadata tools" do
    sign_in_anonymous '132.239.0.3'
    visit dams_collection_path @provCollection
    expect(page).not_to have_link('RDF View', rdf_dams_collection_path(@provCollection.pid))
    expect(page).not_to have_link('Data View', data_dams_collection_path(@provCollection.pid))
    expect(page).not_to have_link('DAMS 4.2 Preview', dams42_dams_collection_path(@provCollection.pid))
  end
  scenario "with dams_curator role should see the metadata tools" do
    sign_in_curator
    visit dams_collection_path @provCollection
    expect(page).to have_link('RDF View', rdf_dams_collection_path(@provCollection.pid))
    expect(page).to have_link('Data View', data_dams_collection_path(@provCollection.pid))
    expect(page).to have_link('DAMS 4.2 Preview', dams42_dams_collection_path(@provCollection.pid))
  end
  scenario "with dams_curator role should not see Mint DOI and Push to OSF" do
    sign_in_curator
    visit dams_collection_path @provCollection
    expect(page).not_to have_content("Mint DOI");
    expect(page).not_to have_content("Push to OSF");
  end
  scenario "with dams_editor role should see Mint DOI and Push to OSF" do
    sign_in_developer
    visit dams_collection_path @provCollection
    expect(page).to have_content("Mint DOI");
    expect(page).to have_content("Push to OSF");
  end
end

feature "Visitor wants to view a collection's page" do
  before(:all) do
    @part = DamsProvenanceCollectionPart.create titleValue: 'Sample Provenance Part', visibility: 'curator'
    @prov = DamsProvenanceCollection.create titleValue: 'Sample Provenance Collection', provenanceCollectionPartURI: @part.pid, visibility: 'curator'
    @part.provenanceCollectionURI = @prov.pid
    @part.save
    solr_index @prov.pid
    solr_index @part.pid
  end

  after(:all) do
    @prov.delete
    @part.delete
  end

  scenario 'should see access control information (curator)' do
    sign_in_developer
    visit dams_collection_path @prov.pid
    expect(page).to have_content('AccessCurator Only')
  end
end

feature "Vistor wants to view the OSF API title" do
  before(:all) do
    @prov = DamsProvenanceCollection.create titleValue: 'Test Title',  titleTranslationVariant: 'Test Translation Variant', visibility: 'curator'
    solr_index @prov.pid
  end

  after(:all) do
    @prov.delete
  end

  scenario 'should see the main title and translation variant separated by colon' do
    sign_in_developer
    visit osf_api_dams_collection_path @prov.pid
    expect(page).to have_content("Test Title : Test Translation Variant")
  end
end

feature "Vistor wants to view the OSF API output" do
  before do
      @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
      @provCollection1 = DamsProvenanceCollection.create(pid: "uu8056206n", visibility: "public")
      @provCollection1.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection_osf.rdf.xml').read
      @provCollection1.save!
      solr_index (@provCollection1.pid)
      @provCollection2 = DamsProvenanceCollection.create titleValue: "Sample Provenance Collection", visibility: "public"
      @provCollection2.save!
      solr_index (@provCollection2.pid)      
    end
    after do
      @provCollection1.delete
      @provCollection2.delete
      @unit.delete
    end
    
    scenario 'should see the following fields' do
      sign_in_developer
      visit osf_api_dams_collection_path @provCollection1.pid
      expect(page).to have_content('"Test Title"')
      expect(page).to have_content('{"name":"test contributor"}')
      expect(page).to have_content('{"name":"test contributor2"}')
      expect(page).to have_content('{"name":"test contributor3"}')
      expect(page).to have_content('{"name":"Test Creator"}')
      expect(page).to have_content('{"name":"test principal investigator"}')
      expect(page).to have_content('{"name":"test author"}')
      expect(page).to have_content("http://library.ucsd.edu/dc/collection/uu8056206n")
      expect(page).to have_content("English")
      expect(page).to have_content("1961")
      expect(page).to have_content("Test Topic")
      expect(page).to have_content("Test Common Name")
      expect(page).to have_content("Test Scientific Name")
      expect(page).to have_content("Test Corporate Name")
      expect(page).to have_content("Test Corporate Name")
      expect(page).to have_content("Test Personal Name")
      expect(page).to have_content("UC San Diego Library, Digital Collections")
      expect(page).to have_content("http://library.ucsd.edu/dc")
    end

    scenario 'should see the default value of Contributor if it is missing from DAMS' do
      sign_in_developer
      visit osf_api_dams_collection_path @provCollection2.pid
      expect(page).to have_content('{"name":"UC San Diego Library"}')
    end
end

feature 'Visitor wants to look at the collection item view search results' do
  before do
    @unit = DamsUnit.create(pid: 'bb45454545')
    @unit.damsMetadata.content = File.new('spec/fixtures/damsUnit.rdf.xml').read
    @unit.save!    
    @aCollection = DamsAssembledCollection.create(pid: "xx4473712z", visibility: "public")
    @aCollection.damsMetadata.content = File.new('spec/fixtures/soccomCollection.rdf.xml').read
    @aCollection.save!
    @soccomObj1 = DamsObject.create(pid: "xx2801340v")
    @soccomObj1.damsMetadata.content = File.new('spec/fixtures/soccomObject1.rdf.xml').read
    @soccomObj1.save!
    @soccomObj2 = DamsObject.create(pid: "xx47126209")
    @soccomObj2.damsMetadata.content = File.new('spec/fixtures/soccomObject2.rdf.xml').read
    @soccomObj2.save!
    @soccomObj3 = DamsObject.create(pid: "xx66239018")
    @soccomObj3.damsMetadata.content = File.new('spec/fixtures/soccomObject3.rdf.xml').read
    @soccomObj3.save!
    solr_index (@unit.pid)
    solr_index (@aCollection.pid)
    solr_index (@soccomObj1.pid)
    solr_index (@soccomObj2.pid)   
    solr_index (@soccomObj3.pid)       
  end
  after do
    @aCollection.delete
    @unit.delete
    @soccomObj1.delete
    @soccomObj2.delete
    @soccomObj3.delete
  end 
  scenario 'should not see html tags for any hightlight field in the search result page' do
    visit catalog_index_path( {:q => "#{@aCollection.pid}", 'sort' => 'title_ssi asc'} )
    expect(page).to have_content('Showing results for 1 - 4 of 4')   
    expect(page).to_not have_content("<a href=\"http://library.ucsd.edu/dc/collection/<span class='search-highlight'>#{@aCollection.pid}</span>\">")
  end

end


feature "Visitor wants to view a UCSD IP only collection's page with metadata-only visibility" do
  before(:all) do
    @localDisplay = DamsOtherRight.create permissionType: "localDisplay"
    @metadataDisplay = DamsOtherRight.create permissionType: "metadataDisplay"
    @metadataOnlyCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with metadata-only visibility", visibility: "local"    
    @localOnlyCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with localDisplay visibility", visibility: "local"    
    @collection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with no localDisplay or metadata-only visibility", visibility: "local"    
    @copyright = DamsCopyright.create status: 'Under copyright'
    @metadataOnlyObj = DamsObject.create titleValue: 'Test Object with metadataOnly Display', provenanceCollectionURI: @metadataOnlyCollection.pid, copyrightURI: @copyright.pid, otherRightsURI: @metadataDisplay.pid
    @localObj = DamsObject.create titleValue: 'Test Object with localDisplay', provenanceCollectionURI: @localOnlyCollection.pid, copyrightURI: @copyright.pid, otherRightsURI: @localDisplay.pid
    @obj = DamsObject.create titleValue: 'Test Object with no localDisplay, no metadataOnlyDisplay', provenanceCollectionURI: @localOnlyCollection.pid, copyrightURI: @copyright.pid
    solr_index @localDisplay.pid
    solr_index @metadataDisplay.pid
    solr_index @metadataOnlyCollection.pid
    solr_index @localOnlyCollection.pid
    solr_index @collection.pid       
    solr_index @copyright.pid
    solr_index @metadataOnlyObj.pid
    solr_index @localObj.pid
    solr_index @obj.pid
  end

  after(:all) do
    @localDisplay.delete
    @metadataDisplay.delete
    @metadataOnlyCollection.delete
    @localOnlyCollection.delete
    @collection.delete   
    @copyright.delete
    @metadataOnlyObj.delete
    @localObj.delete
    @obj.delete
  end

  scenario 'should see Restricted View access control information' do
    sign_in_anonymous '132.239.0.3'
    visit dams_collection_path @metadataOnlyCollection.pid
    expect(page).to have_content('Restricted View')
    visit dams_collection_path @localOnlyCollection.pid
    expect(page).to have_content('Restricted View')
  end

  scenario 'should not see Restricted View access control information' do
    sign_in_anonymous '132.239.0.3'
    visit dams_collection_path @collection.pid
    expect(page).to_not have_content('Restricted View')
  end
end