require 'spec_helper'

feature 'Visitor wants to search' do
  before(:all) do
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @copy = DamsCopyright.create status: "Public domain"

    @sub1 = MadsTopic.create name: 'ZZZ Test Subject 1'
    @sub2 = MadsTopic.create name: 'ZZZ Test Subject 2'

    @obj1 = DamsObject.create titleValue: "Sample Object 1", unitURI: @unit.pid, copyrightURI: @copy.pid, beginDate: '2000', subjectURI: [@sub1.pid]
    @obj2 = DamsObject.create titleValue: "Sample Object 2", unitURI: @unit.pid, copyrightURI: @copy.pid, beginDate: '1999', subjectURI: [@sub2.pid]
    @obj3 = DamsObject.create titleValue: "Sample Object 3", unitURI: @unit.pid, copyrightURI: @copy.pid

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
  end

  scenario 'is on search results page' do
    visit catalog_index_path( {:q => 'Sample'} )
    expect(page).to have_selector('h4', :text => 'Refine your search')
    expect(page).to have_selector('h3', :text => 'Sample Object 1')
    expect(page).to have_selector('h3', :text => 'Sample Object 2')
    expect(page).to have_selector('h3', :text => 'Sample Object 3')
  end
  scenario 'is on a browse results page' do
    # should show links to remove facets, even when there is no query
    visit catalog_index_path( {'f[unit_sim][]' => 'Test Unit'} )
    expect(page).to have_selector("div.dams-search-constraints")
    expect(page).to have_selector("span.dams-filter")
  end
  scenario 'results sorted by title' do
    sign_in_developer
    visit catalog_index_path( {'q' => 'sample', 'per_page' => 100, 'sort' => 'title_ssi asc'} )
    idx1 = page.body.index('Sample Object 1')
    idx2 = page.body.index('Sample Object 2')
    idx3 = page.body.index('Sample Object 3')
    idx2.should > idx1
    idx3.should > idx2

    click_on "Sample Object 1"
    expect(page).to have_selector('div.search-results-pager')
  end

  scenario 'Search with single or double quotes' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h3', :text => 'Sample Object 1')
    
    visit catalog_index_path( {:q => '"sample'} )
    expect(page).to have_selector('h3', :text => 'Sample Object 1')
    
    visit catalog_index_path( {:q => 'sample"'} )
    expect(page).to have_selector('h3', :text => 'Sample Object 1')    

    visit catalog_index_path( {:q => 'sample""'} )
    expect(page).to have_selector('h3', :text => 'Sample Object 1')    
    
    visit catalog_index_path( {:q => '""sample'} )
    expect(page).to have_selector('h3', :text => 'Sample Object 1')   
    
    visit catalog_index_path( {:q => '"sample"'} )
    expect(page).to have_selector('h3', :text => 'Sample Object 1') 
  end

  scenario 'results sorted by object creation date' do
    sign_in_developer
    visit catalog_index_path( {'f[unit_sim][]' => 'Test Unit', 'per_page' => 100, 'sort' => 'object_create_dtsi asc'} )
    idx1 = page.body.index('Sample Object 1')  # 2000
    idx2 = page.body.index('Sample Object 2')  # 1999
    idx3 = page.body.index('Sample Object 3')  # no date
    idx3.should >( idx2 )
    idx2.should >( idx1 )

    click_on "Sample Object 3"
    expect(page).to have_selector('div.search-results-pager')
  end
  scenario 'system queries should show search results' do
    visit catalog_index_path( {:fq => ['{!join from=collections_tesim to=id}unit_code_tesim:tu']} )
    expect(page).to have_selector('ol#dams-search-results li div h3')
  end
  scenario 'should see the constraints' do
    visit catalog_index_path( {:q => 'sample'} )
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
end

feature "Search and browse linked names and subjects" do
  before(:all) do
    @damsObj = DamsObject.create(pid: 'bd08080808')
    @damsObj.damsMetadata.content = File.new('spec/fixtures/damsObjectDuplicatedNames.rdf.xml').read
    @damsObj.save!
    solr_index @damsObj.pid
  end
  after(:all) do
    @damsObj.delete
  end
  scenario "Record with duplicate name entries" do
    pending "working object metadata updating"
    sign_in_developer
    # Create a sample object with subtitle and variant titles

    # search display
    visit catalog_index_path( {:q => '"Record With Duplicated Names"'} )
    expect(page).to have_content('ZZZ Name, Duplicated')
    expect(page).to have_content('ZZZ Name, Singleton')
    expect(page).not_to have_content('ZZZ Name, Duplicatd; ZZZ Name, Duplicated')
  end
  scenario 'Browse by name' do
    pending "working object metadata updating"
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
  end

  scenario 'search with filter query' do
    visit catalog_index_path( {q: 'query sample', fq: ['title_tesim:1']} )
    expect(page).to have_selector('h3', text: 'Query Sample 1')
    expect(page).not_to have_selector('h3', text: 'Query Sample 2')
  end
end
