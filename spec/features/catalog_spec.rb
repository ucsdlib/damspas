require 'spec_helper'

feature 'Visitor wants to search' do
  before(:all) do
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @copy = DamsCopyright.create status: "Public domain"

    @sub1 = MadsTopic.create name: 'ZZZ Test Subject 1'
    @sub2 = MadsTopic.create name: 'ZZZ Test Subject 2'

    @obj1 = DamsObject.create titleValue: "QE8iWjhafTRpc Object 1", unitURI: @unit.pid, copyrightURI: @copy.pid, beginDate: '2000', subjectURI: [@sub1.pid]
    @obj2 = DamsObject.create titleValue: "QE8iWjhafTRpc Object 2", unitURI: @unit.pid, copyrightURI: @copy.pid, beginDate: '1999', subjectURI: [@sub2.pid]
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

    @sub1.delete
    @sub2.delete
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
    idx2.should > idx1
    idx3.should > idx2

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

  scenario 'results sorted by object creation date' do
    sign_in_developer
    visit catalog_index_path( {'f[unit_sim][]' => 'Test Unit', 'per_page' => 100, 'sort' => 'object_create_dtsi asc'} )
    idx1 = page.body.index('QE8iWjhafTRpc Object 1')  # 2000
    idx2 = page.body.index('QE8iWjhafTRpc Object 2')  # 1999
    idx3 = page.body.index('QE8iWjhafTRpc Object 3')  # no date
    idx3.should >( idx2 )
    idx2.should >( idx1 )

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
    idx2.should >( idx1 )
    
    click_on("Sort 1-9", match: :first)
    expect(page).to have_selector('.btn', :text => 'Z')
    idx1 = page.body.index('ZZZ Test Subject 1')
    idx2 = page.body.index('ZZZ Test Subject 2')
    idx1.should <( idx2 )
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
    expect(page).to have_content('Components of "The Record With Duplicated Names"')
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

feature 'Visitor wants to download JSON' do
  scenario 'Performing a search' do
    visit catalog_index_path( {:q => 'sample', :format => 'json'} )
    page.status_code.should == 200
    page.response_headers['Content-Type'].should include 'application/json'
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
  scenario 'should see the results page with collection info' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h3', :text => 'Sample Image Component')   
    expect(page).to have_selector("span.dams-search-results-fields-label:first", :text => 'Collection:')     
  end
  
  scenario 'should see the results page with multiple collection display' do
    visit catalog_index_path( {:q => 'The Sample Simple Object: An Image Object'} )
    expect(page).to have_selector('h3', :text => 'The Sample Simple Object: An Image Object')   
    expect(page).to have_selector("span.dams-search-results-fields-label:first", :text => 'Collection:')
    expect(page).to have_selector("ul.dams-search-results-fields:first li span[2]", :text => 'Sample Assembled Collection, The: Subtitle, Allegro, 1; Sample Provenance Part, The: Subtitle, Allegro, 1')    
  end
  
  scenario 'should see the collection info before other fields in single object viewer' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h3', :text => 'Sample Image Component')   
    click_on "Sample Image Component"
    expect(page).to have_selector("dt:first", :text => 'Collection')     
  end
end