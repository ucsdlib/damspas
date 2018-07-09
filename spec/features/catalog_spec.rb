require 'spec_helper'

feature 'Visitor wants to search' do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @copy = DamsCopyright.create status: "Public domain"

    @topic1 = MadsTopic.create name: 'ZZZ Test Subject 1'
    @topic2 = MadsTopic.create name: 'ZZZ Test Subject 2'

    @obj1 = DamsObject.create titleValue: "QE8iWjhafTRpc Object 1", unitURI: @unit.pid, copyrightURI: @copy.pid, date_attributes: [{type: 'creation', beginDate: '2000-05-10', endDate: '2050-05-11', value: '2000-05-10 to 2050-05-11'}], topic_attributes: [{ id: RDF::URI.new("#{ns}#{@topic1.pid}") }]
    @obj2 = DamsObject.create titleValue: "QE8iWjhafTRpc Object 2", unitURI: @unit.pid, copyrightURI: @copy.pid, date_attributes: [{type: 'creation', beginDate: '1999', value: '1999'}], topic_attributes: [{ id: RDF::URI.new("#{ns}#{@topic2.pid}") }]
    @obj3 = DamsObject.create titleValue: "QE8iWjhafTRpc Object 3", unitURI: @unit.pid, copyrightURI: @copy.pid
  
    solr_index @obj1.pid
    solr_index @obj2.pid
    solr_index @obj3.pid
    
  end
  after(:all) do
    @obj1.delete
    @obj2.delete
    @obj3.delete

    @copy.delete
    @unit.delete

    @topic1.delete
    @topic2.delete
  end

  scenario 'result page displays topics' do
    visit catalog_index_path( {:q => 'QE8iWjhafTRpc'} )
    expect(page).to have_content('ZZZ Test Subject 1')
    expect(page).to have_content('ZZZ Test Subject 2')
  end

  scenario 'display search box when there are no search results' do
    visit catalog_index_path( {:q => 'fish'} )
    expect(page).to have_selector('#search-button')
  end

  scenario 'is on search results page' do
    visit catalog_index_path( {:q => 'QE8iWjhafTRpc'} )    
    expect(page).to have_selector('h4', :text => 'Refine your search')
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 1')
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 2')
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 3')
  end
  scenario 'is on a browse results page' do
    # should show links to remove facets, even when there is no query
    visit catalog_index_path( {'f[unit_sim][]' => 'Test Unit'} )
    expect(page).to have_selector("div.dams-search-constraints")
    expect(page).to have_selector("span.dams-filter")
  end
  scenario 'results sorted by title' do
    sign_in_developer
    visit catalog_index_path( {'q' => 'QE8iWjhafTRpc', 'per_page' => 100, 'sort' => 'title_ssi asc'} )
    idx1 = page.body.index('QE8iWjhafTRpc Object 1')
    idx2 = page.body.index('QE8iWjhafTRpc Object 2')
    idx3 = page.body.index('QE8iWjhafTRpc Object 3')
    expect(idx2).to be > idx1
    expect(idx3).to be > idx2

    click_on "QE8iWjhafTRpc Object 1"
    expect(page).to have_selector('div.search-results-pager')
  end

  scenario 'Search with single or double quotes' do
    visit catalog_index_path( {:q => 'QE8iWjhafTRpc'} )
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 1')
    
    visit catalog_index_path( {:q => '"QE8iWjhafTRpc'} )
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 1')
    
    visit catalog_index_path( {:q => 'QE8iWjhafTRpc"'} )
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 1')    

    visit catalog_index_path( {:q => 'QE8iWjhafTRpc""'} )
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 1')    
    
    visit catalog_index_path( {:q => '""QE8iWjhafTRpc'} )
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 1')   
    
    visit catalog_index_path( {:q => '"QE8iWjhafTRpc"'} )
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 1') 
  end

  scenario 'results sorted by object creation date should work for both single date and range date' do
    sign_in_developer
    visit catalog_index_path( {'f[unit_sim][]' => 'Test Unit', 'per_page' => 100, 'sort' => 'object_create_dtsi asc'} )
    idx1 = page.body.index('QE8iWjhafTRpc Object 3')  # no date
    idx2 = page.body.index('QE8iWjhafTRpc Object 2')  # 1999
    idx3 = page.body.index('QE8iWjhafTRpc Object 1')  # 2000-2008
    expect(idx3).to be >( idx2 )
    expect(idx2).to be >( idx1 )

    click_on "QE8iWjhafTRpc Object 3"
    expect(page).to have_selector('div.search-results-pager')
  end
  scenario 'system queries should show search results' do
    visit catalog_index_path( {:fq => ['{!join from=collections_tesim to=id}unit_code_tesim:tu']} )
    expect(page).to have_selector('ol#dams-search-results li div h3')
  end
  scenario 'should see the constraints' do
    visit catalog_index_path( {:q => 'QE8iWjhafTRpc'} )
    expect(page).to have_selector('span.dams-filter a')
  end

  scenario 'Browse by Topic page' do
    visit catalog_facet_path("subject_topic_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    
    expect(page).to have_selector('.btn', :text => 'Z')
    idx1 = page.body.index('ZZZ Test Subject 1')
    idx2 = page.body.index('ZZZ Test Subject 2')
    expect(idx2).to be >( idx1 )
    
    click_on("Sort 1-9", match: :first)
    expect(page).to have_link('A', href: '/search/facet/subject_topic_sim?facet.prefix=A&facet.sort=index' )
    expect(page).to have_selector('.btn', :text => 'Z')
    idx1 = page.body.index('ZZZ Test Subject 1')
    idx2 = page.body.index('ZZZ Test Subject 2')
    expect(idx1).to be <( idx2 )
  end  

  scenario 'search results paging' do
    visit catalog_index_path( {'q' => 'QE8iWjhafTRpc', 'sort' => 'title_ssi asc'} )
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 1')
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 2')
    expect(page).to have_selector('h3', :text => 'QE8iWjhafTRpc Object 3')

    # viewing item from search results should have pager
    click_on "QE8iWjhafTRpc Object 2"
    expect(page).to have_selector('div', :text => 'Previous 2 of 3 results Next')
    expect(page).to have_link('Previous', href: dams_object_path(@obj1, counter: 1) )
    expect(page).to have_link('Next', href: dams_object_path(@obj3, counter: 3) )

    # pager should remain when paging through results
    click_on "Next"
    expect(page).to have_link('Previous', href: dams_object_path(@obj2, counter: 2) )
    expect(page).to have_selector('div', :text => 'Previous 3 of 3 results')

    # should not have pager on direct links
    visit dams_object_path @obj1
    expect(page).to_not have_selector('div', :text => 'Previous 3 of 3 results')
  end

  scenario 'should mark curator access in document link' do
  	sign_in_developer
    visit catalog_index_path( {:q => '"QE8iWjhafTRpc Object 1"'} )
    expect(page).to have_xpath "//a[contains(@href,'?counter=1&access=curator')]"
    expect(page).to have_link('QE8iWjhafTRpc Object 1', href:"/object/#{@obj1.pid}?counter=1&access=curator")
  end
 
  scenario 'decade faceting displays in chronological order ' do
    visit catalog_index_path( {'q' => 'QE8iWjhafTRpc'} )
    expect(page).to have_link('2000s', href: catalog_index_path({'f[decade_sim][]' => '2000s', 'q' => 'QE8iWjhafTRpc'}))
    expect(page).to have_selector("div.blacklight-decade_sim ul li[1]", :text => '2050s 1') 
    expect(page).to have_selector("div.blacklight-decade_sim ul li[2]", :text => '2040s 1') 
    expect(page).to have_selector("div.blacklight-decade_sim ul li[3]", :text => '2030s 1') 
    expect(page).to have_selector("div.blacklight-decade_sim ul li[4]", :text => '2020s 1') 
    expect(page).to have_selector("div.blacklight-decade_sim ul li[5]", :text => '2010s 1')  
    expect(page).to have_selector("div.blacklight-decade_sim ul li[6]", :text => '2000s 1')
    expect(page).to have_selector("div.blacklight-decade_sim ul li[7]", :text => '1990s 1')
  end
end

feature "Search and browse links and subjects" do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @role = MadsAuthority.create name: 'Creator', code: 'cre'
    @name1 = MadsName.create name: 'ZZZ Name, Duplicated'
    @name2 = MadsName.create name: 'ZZZ Name, Singleton'
    @obj = DamsObject.create( titleValue: 'Record With Duplicated Names',
      titleNonSort: 'The',
      component_attributes: [{titleValue: 'Comp 1'}, {titleValue: 'Comp 2'}],
      relationship_attributes: [
        {name: [RDF::URI.new("#{ns}#{@name1.pid}")], role: [RDF::URI.new("#{ns}#{@role.pid}")]},
        {name: [RDF::URI.new("#{ns}#{@name2.pid}")], role: [RDF::URI.new("#{ns}#{@role.pid}")]},
        {name: [RDF::URI.new("#{ns}#{@name1.pid}")], role: [RDF::URI.new("#{ns}#{@role.pid}")]}  ])
    solr_index @obj.pid
  end
  after(:all) do
    @obj.delete
    @name1.delete
    @name2.delete
    @role.delete
  end
  scenario "Title with non filing characters" do
    sign_in_developer
    # search display
    visit catalog_index_path( {:q => '"Record With Duplicated Names"'} )

    # The document link includes the non-filing characters
    expect(page).to have_content('The Record With Duplicated Names')

    # the title and the top component tree link should include the non-filing characters
    click_on "The Record With Duplicated Names"
    expect(page).to have_selector('h1',:text=>'The Record With Duplicated Names')
    expect(page).to have_content('Components')
  end
  scenario "Record with duplicate name entries" do
    sign_in_developer
    # Create a sample object with subtitle and variant titles

    # search display
    visit catalog_index_path( {:q => '"Record With Duplicated Names"'} )
    expect(page).to have_content('ZZZ Name, Duplicated')
    expect(page).to have_content('ZZZ Name, Singleton')
    expect(page).not_to have_content('ZZZ Name, Duplicatd; ZZZ Name, Duplicated')
  end
  scenario 'Browse by name' do
    sign_in_developer
    visit catalog_facet_path("creator_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    expect(page).to have_content('ZZZ Name, Duplicated')
    expect(page).to have_content('ZZZ Name, Singleton')
  end
end

feature "Search and browse custom subject facet links" do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @copy = DamsCopyright.create status: "Public domain"
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @anatomy = DamsAnatomy.create( name: 'ZZZ Test Anatomy' )
    @common = DamsCommonName.create( name: 'ZZZ Test Common Name' )
    @cruise = DamsCruise.create( name: 'ZZZ Test Cruise' )
    @cultural = DamsCulturalContext.create( name: 'ZZZ Test Cultural Context' )
    @lithology = DamsLithology.create( name: 'ZZZ Test Lithology' )
    @science = DamsScientificName.create( name: 'ZZZ Test Scientific Name' )
    @series = DamsSeries.create( name: 'ZZZ Test Series' )
    @obj = DamsObject.create( 
        titleValue: 'QE8iWjhafTRpc Test Object', 
        unitURI: @unit.pid, 
        copyrightURI: @copy.pid, 
        anatomy_attributes: [{ id: RDF::URI.new("#{ns}#{@anatomy.pid}") }],
        commonName_attributes: [{ id: RDF::URI.new("#{ns}#{@common.pid}") }],
        cruise_attributes: [{ id: RDF::URI.new("#{ns}#{@cruise.pid}") }],
        culturalContext_attributes: [{ id: RDF::URI.new("#{ns}#{@cultural.pid}") }],
        lithology_attributes: [{ id: RDF::URI.new("#{ns}#{@lithology.pid}") }],
        scientificName_attributes: [{ id: RDF::URI.new("#{ns}#{@science.pid}") }],
        series_attributes: [{ id: RDF::URI.new("#{ns}#{@series.pid}") }],
        )

    solr_index @obj.pid
  end
  after(:all) do
    @obj.delete
    @unit.delete
    @copy.delete
    @anatomy.delete
    @common.delete
    @cruise.delete
    @cultural.delete
    @lithology.delete
    @science.delete
    @series.delete
  end

  scenario 'should has facet Anatomy in search result' do
    sign_in_developer
    visit catalog_index_path( {:q => 'QE8iWjhafTRpc Test Object'} )
    expect(page).to have_link('Anatomy', href: '#' )
  end
  scenario 'Browse by anatomy' do
    sign_in_developer
    visit catalog_facet_path("subject_anatomy_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    expect(page).to have_content('ZZZ Test Anatomy')
    click_on "ZZZ Test Anatomy"
    expect(page).to have_content('QE8iWjhafTRpc Test Object')
  end
  scenario 'Browse by common name' do
    sign_in_developer
    visit catalog_facet_path("subject_common_name_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    expect(page).to have_content('ZZZ Test Common Name')
    click_on "ZZZ Test Common Name"
    expect(page).to have_content('QE8iWjhafTRpc Test Object')
  end
    scenario 'Browse by cruise' do
    sign_in_developer
    visit catalog_facet_path("subject_cruise_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    expect(page).to have_content('ZZZ Test Cruise')
    click_on "ZZZ Test Cruise"
    expect(page).to have_content('QE8iWjhafTRpc Test Object')
  end
  scenario 'Browse by cultural context' do
    sign_in_developer
    visit catalog_facet_path("subject_cultural_context_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    expect(page).to have_content('ZZZ Test Cultural Context')
    click_on "ZZZ Test Cultural Context"
    expect(page).to have_content('QE8iWjhafTRpc Test Object')
  end
    scenario 'Browse by lithology' do
    sign_in_developer
    visit catalog_facet_path("subject_lithology_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    expect(page).to have_content('ZZZ Test Lithology')
    click_on "ZZZ Test Lithology"
    expect(page).to have_content('QE8iWjhafTRpc Test Object')
  end    
  scenario 'Browse by scientific name' do
    sign_in_developer
    visit catalog_facet_path("subject_scientific_name_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    expect(page).to have_content('ZZZ Test Scientific Name')
    click_on "ZZZ Test Scientific Name"
    expect(page).to have_content('QE8iWjhafTRpc Test Object')
  end
  scenario 'Browse by series' do
    sign_in_developer
    visit catalog_facet_path("subject_series_sim", :'facet.sort' => 'index', :'facet.prefix' => 'Z')
    expect(page).to have_content('ZZZ Test Series')
    click_on "ZZZ Test Series"
    expect(page).to have_content('QE8iWjhafTRpc Test Object')
  end
  scenario 'topic faceting displays exclude anatomy, cultureContext, series, lithology, common name, scientific name and cruise values' do
    visit catalog_index_path( {'q' => @obj.pid} )
    expect(page).to have_selector("div.blacklight-subject_topic_sim ul li", :count => 0)     
  end   
end

describe "Search and browse custom subject facets from complex object" do
  before(:all) do
    @damsComplexObj = DamsObject.create pid: "xx808080zz"
    @damsComplexObj.damsMetadata.content = File.new( "spec/fixtures/damsComplexObject9.rdf.xml" ).read
    @damsComplexObj.save!
    solr_index (@damsComplexObj.pid)
  end
  after(:all) do
    @damsComplexObj.delete
  end

  it "Browse by common name should include subjects from both object and components" do
    sign_in_developer
    visit catalog_facet_path("subject_common_name_sim", :'facet.sort' => 'index')
    expect(page).to have_content('ZZZ Test Common Name in Object')
    expect(page).to have_content('ZZZ Test Common Name in Component')
    click_on "ZZZ Test Common Name in Component"
    expect(page).to have_content('Test Complex Object 9')
  end
end

feature 'Visitor wants to download JSON' do
  scenario 'Performing a search' do
    visit catalog_index_path( {:q => 'sample', :format => 'json'} )
    expect(page.status_code).to eq(200)
    expect(page.response_headers['Content-Type']).to include 'application/json'
  end
end

feature 'Visitor wants to limit search with a provided Solr filter query' do
  before do
    @public = DamsCopyright.create(status: "Public domain")
    @obj1 = DamsObject.create(titleValue: "Query Sample 1", copyrightURI: @public.pid)
    solr_index @obj1.pid
    @obj2 = DamsObject.create(titleValue: "Query Sample 2", copyrightURI: @public.pid)
    solr_index @obj2.pid
  end
  after do
    @obj1.delete
    @obj2.delete
    @public.delete
  end

  scenario 'search with filter query' do
    visit catalog_index_path( {q: 'query sample', fq: ['title_tesim:1']} )
    expect(page).to have_selector('h3', text: 'Query Sample 1')
    expect(page).not_to have_selector('h3', text: 'Query Sample 2')
  end
end

feature 'Visitor wants to see collection info in the search results view' do
  before(:all) do
      @acol = DamsAssembledCollection.create( titleValue: 'Sample Assembled Collection',
              subtitle: 'Subtitle', titleNonSort: 'The', titlePartName: 'Allegro', titlePartNumber: '1',
              visibility: 'public' )
      @part = DamsProvenanceCollectionPart.create( titleValue: 'Sample Provenance Part',
              subtitle: 'Subtitle', titleNonSort: 'The', titlePartName: 'Allegro', titlePartNumber: '1',
              visibility: 'public' )
      @unit = DamsUnit.create( name: 'Test Unit', description: 'Test Description', code: 'tu',
              group: 'dams-curator', uri: 'http://example.com/' )
      @obj  = DamsObject.create( titleValue: 'YQu9XjFgDT4UYA7WBQRsg Object',
              assembledCollectionURI: [ @acol.pid ], provenanceCollectionPartURI: [ @part.pid ],
              unit_attributes: [{ id: RDF::URI.new("#{Rails.configuration.id_namespace}#{@unit.pid}") }],
              copyright_attributes: [{status: 'Public domain'}] )
    solr_index @acol.pid
    solr_index @obj.pid
  end
  after(:all) do
    @obj.delete
    @acol.delete
    @part.delete
    @unit.delete
  end
  scenario 'should see the results page with collection info' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h3', :text => 'YQu9XjFgDT4UYA7WBQRsg Object')   
    expect(page).to have_selector("span.dams-search-results-fields-label:first", :text => 'Collection:')     
  end
  
  scenario 'should see the results page with multiple collection display' do
    visit catalog_index_path( {:q => 'YQu9XjFgDT4UYA7WBQRsg Object'} )
    expect(page).to have_selector('h3', :text => 'YQu9XjFgDT4UYA7WBQRsg Object')   
    expect(page).to have_selector("span.dams-search-results-fields-label:first", :text => 'Collection:')
    expect(page).to have_selector("ul.dams-search-results-fields:first li span[2]", :text => 'The Sample Assembled Collection: Subtitle, Allegro, 1')    
    expect(page).to have_selector("ul.dams-search-results-fields:first li span[2]", :text => 'The Sample Provenance Part: Subtitle, Allegro, 1')    
  end
  
  scenario 'should see the collection info before other fields in single object viewer' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h3', :text => 'YQu9XjFgDT4UYA7WBQRsg Object')   
    click_on "YQu9XjFgDT4UYA7WBQRsg Object"
    expect(page).to have_selector("dt:first", :text => 'Collection')
  end

  scenario 'should not see access control information (public) in single object viewer' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h3', :text => 'YQu9XjFgDT4UYA7WBQRsg Object')
    click_on "YQu9XjFgDT4UYA7WBQRsg Object"
    expect(page).to have_no_content('AccessPublic')
  end

  scenario 'should see search this collection text in the search box' do
    sign_in_developer
    visit dams_collection_path @acol.pid
    click_link('View Collection Items', match: :first)
    expect(find('#q')['placeholder']).to eq('Search this collection...')
  end
end

#---

feature 'User wants to see search results' do
  before(:all) do
    @unit = DamsUnit.create name: 'Test Unit', description: 'Test Description', code: 'tu', uri: 'http://example.com/', group: 'dams-curator'
    @copy = DamsCopyright.create status: 'Public domain'
    @sub1 = MadsTopic.create name: 'ZZZ Test Subject 1'
    @sub2 = MadsTopic.create name: 'ZZZ Test Subject 2'
    @obj1 = DamsObject.create titleValue: 'QE8iWjhafTRpc Object 1', unitURI: @unit.pid, copyrightURI: @copy.pid, date_attributes: [{type: 'creation', beginDate: '2000-05-10', endDate: '2050-05-11', value: '2000-05-10 to 2050-05-11'}], subjectURI: [@sub1.pid]
    @obj2 = DamsObject.create titleValue: 'QE8iWjhafTRpc Object 2', unitURI: @unit.pid, copyrightURI: @copy.pid, date_attributes: [{type: 'creation', beginDate: '1999', value: '1999'}], subjectURI: [@sub2.pid]
    @obj3 = DamsObject.create titleValue: 'QE8iWjhafTRpc Object 3', unitURI: @unit.pid
    solr_index @obj1.pid
    solr_index @obj2.pid
    solr_index @obj3.pid
  end

  after(:all) do
    @obj1.delete
    @obj2.delete
    @obj3.delete
    @copy.delete
    @unit.delete
    @sub1.delete
    @sub2.delete
  end

  scenario 'should see access control information (curator)' do
    sign_in_developer
    visit catalog_index_path( {:q => 'QE8iWjhafTRpc'} )
    expect(page).to have_content('Access: Curator Only')
  end

  scenario 'should not see access control information (public)' do
    sign_in_developer
    visit catalog_index_path( {:q => 'QE8iWjhafTRpc'} )
    expect(page).to have_no_content('Access: Public')
  end
end

feature 'Visitor wants to view icons for the objects in the search result page' do
  before(:all) do
    @unit = DamsUnit.create pid: 'xx48484848', name: "Test Unit", description: "Test Description",
                code: "tu", uri: "http://example.com/"
    @obj1 = DamsObject.create( titleValue: 'Music Test', typeOfResource: 'sound recording',
                unitURI: [ @unit.pid ], copyright_attributes: [{status: 'Public domain'}] )
    mp3_content = "//tQxAAAAAAAAAAAAAAAAAAAAAAASW5mbwAAAA8AAAACAAACcQCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA//////////////////////////////////////////////////////////////////8AAAA5TEFNRTMuOTlyAaUAAAAALf4AABRAJAaWQgAAQAAAAnEy8lFkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/7UMQAAAdsJSBAmMBBKIbj2JSY0QAEoeCBAABBBDYMIECBAhDwQBAMQQdSGP5QHwfB/98Tg+DgIAgCDvBx38oc/lAQd+jkAf//AgIO6wfD4mkEpBZEiRSshCoVCwJBoEiZpyIBJEiVeSJEiFPxdBBQUF/+BQUEgvhQV4UFBQSCgoKChX9BTf/+RQUFN/8QUF/8QU34oKC/0FBVTEFNRTMuOTkuNVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/+1LEGoPAAAGkAAAAIAAANIAAAARVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVQ=="
    @obj1.add_file( Base64.decode64(mp3_content), "_1.mp3", "test.mp3" )
    @obj2 = DamsObject.create pid: "xx808080zz"
    @obj2.damsMetadata.content = File.new( "spec/fixtures/damsComplexObject9.rdf.xml" ).read
    @obj1.save
    @obj2.save!

    solr_index  (@obj1.pid)
    solr_index (@obj2.pid)
  end
  after(:all) do
    @obj1.delete
    @obj2.delete
    @unit.delete
  end
  scenario 'rendering the folder icon for complex object which has more than one format type' do
    sign_in_developer
    visit catalog_index_path({:q => 'xx808080zz'})
    expect(page).to have_selector('.glyphicon-folder-open')
  end

  scenario 'rendering the format speific icon for object which has one format type' do
    sign_in_developer
    visit catalog_index_path({:q => @obj1.pid})
    expect(page).to have_selector('.glyphicon-volume-up')
  end
end

feature 'Visitor wants to view object of metadata data-only visibility collection in the search result page' do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @note = DamsNote.create type: "local attribution", value: "Digital Library Development Program, UC San Diego, La Jolla, 92093-0175"
    @localDisplay = DamsOtherRight.create permissionType: "localDisplay"
    @localOnlyCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with localDisplay visibility", visibility: "local"    
    @localObj = DamsObject.create pid: 'xx909090zz', titleValue: 'Test Object with localDisplay', provenanceCollectionURI: @localOnlyCollection.pid, otherRightsURI: @localDisplay.pid, note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }], copyright_attributes: [{status: 'Public domain'}]
    solr_index @note.pid
    solr_index @localDisplay.pid
    solr_index @localOnlyCollection.pid
    solr_index @localObj.pid
  end
  after(:all) do
    @note.delete
    @localDisplay.delete
    @localOnlyCollection.delete
    @localObj.delete
  end
  scenario 'rendering the grey generic thumbnail and restricted access info' do
    sign_in_developer
    visit catalog_index_path({:q => 'xx909090zz'})
    expect(page).to have_css('img.dams-search-thumbnail[src="https://library.ucsd.edu/assets/dams/site/thumb-restricted.png"]')
    expect(page).to have_content('Restricted View')
  end
end

feature 'Visitor wants to view localDisplay License object in UCSD local collection in the search result page' do
  before(:all) do
    ns = Rails.configuration.id_namespace
    @note = DamsNote.create type: "local attribution", value: "Digital Library Development Program, UC San Diego, La Jolla, 92093-0175"
    @localDisplay = DamsLicense.create permissionType: "localDisplay"
    @localOnlyCollection = DamsProvenanceCollection.create titleValue: "Test UCSD IP only Collection with localDisplay visibility", visibility: "local"
    @localObj = DamsObject.create titleValue: 'Test Object with localDisplay', provenanceCollectionURI: @localOnlyCollection.pid, licenseURI: @localDisplay.pid, note_attributes: [{ id: RDF::URI.new("#{ns}#{@note.pid}") }], copyright_attributes: [{status: 'Unknown'}]
    solr_index @note.pid
    solr_index @localDisplay.pid
    solr_index @localOnlyCollection.pid
    solr_index @localObj.pid
  end
  after(:all) do
    @note.delete
    @localDisplay.delete
    @localOnlyCollection.delete
    @localObj.delete
  end
  scenario 'rendering the grey generic thumbnail and restricted access info' do
    sign_in_developer
    visit catalog_index_path({:q => @localObj.pid})
    expect(page).to have_css('img.dams-search-thumbnail[src="https://library.ucsd.edu/assets/dams/site/thumb-restricted.png"]')
    expect(page).to have_content('Restricted View')
  end
end

feature 'Visitor wants to view contact form' do
  scenario 'rendering the contact form' do
    sign_in_developer
    visit contact_path
    expect(page).to have_content('Contact Us')
    expect(page).to have_selector('#mf_placeholder')
  end
end
