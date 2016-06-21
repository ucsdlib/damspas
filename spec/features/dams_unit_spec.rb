require 'spec_helper'

feature 'Units' do
  before(:all) do
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @copy = DamsCopyright.create status: "Public domain"
    @obj = DamsObject.create unitURI: @unit.pid, titleValue: "First Test Object", copyrightURI: @copy.pid
    @col = DamsAssembledCollection.create(unitURI: @unit.pid, titleValue: 'Test Bee Collection', visibility: 'public', scopeContentNote_attributes:[{value:'Test scope content note'}])

    @unit2 = DamsUnit.create name: "Another Test Unit", description: "Another Test Description", code: "ano", uri: "http://example.com/"
    @obj2 = DamsObject.create unitURI: @unit2.pid, titleValue: "Another Test Object", copyrightURI: @copy.pid
    @col2 = DamsAssembledCollection.create(unitURI: @unit2.pid, titleValue: 'Test Collection', visibility: 'public', scopeContentNote_attributes:[{value:'Test scope content note'}])

    @unit3 = DamsUnit.create name: "UCSD Research Data Collections Test", description: "Test Description", code: "rdcpt", uri: "http://example.com/"

    solr_index @col.pid
    solr_index @col2.pid
    solr_index @unit2.pid
    solr_index @obj2.pid
    solr_index @obj.pid
    solr_index @unit.pid
    solr_index @unit3.pid
  end
  after(:all) do
    @obj.delete
    @obj2.delete
    @col.delete
    @col2.delete
    @copy.delete
    @unit.delete
    @unit2.delete
    @unit3.delete
  end

  scenario 'is on units landing page' do
    visit dams_units_path
    expect(page).to have_selector('a', :text => 'Collection')
    expect(page).to have_selector('a', :text => 'Format')
    expect(page).to have_selector('a', :text => 'Topic')

    expect(page).to have_field('Search...')
  end

  scenario 'retrieve a unit record' do
    sign_in_developer
    visit dams_units_path
    expect(page).to have_field('Search...')
    fill_in 'Search...', :with => @unit.pid, :match => :prefer_exact

    click_on('search-button')

    # Check description on the page
    expect(page).to have_content(@unit.pid)
  end

  scenario 'unit pages should have scoped browse links' do
    visit dams_unit_path :id => 'tu'
    expect(page).to have_selector('h1', :text => 'Test Unit')

    # browse links should be scoped to the unit
    topiclink = find('ul.sidebar-button-list li a', text: "Topic")
  end

  scenario 'scoped search (inclusion)' do
    # search for the object in the unit and find it
    visit catalog_index_path( {'f[unit_sim][]' => 'Test Unit', :q => 'test'} )
    expect(page).to have_content('Search Results')
    expect(page).to have_content('First Test Object')
  end

  scenario 'scoped search (exclusion)' do
    visit dams_unit_path :id => 'ano'
    expect(page).to have_selector('h1', :text => 'Another Test Unit')

    # search for the object in the unit and find it
    visit catalog_index_path( {'f[unit_sim][]' => 'Another+Test+Unit', :q => 'test'} )
    expect(page).to have_no_content('First Test Object')
  end

  scenario 'an anonymous user' do
    visit dams_unit_collections_path('ano')
    expect(page).to have_selector('h3','Browse by Collection: Another Test Unit')
    expect(page).to have_selector('a', :text => 'Test Collection')
    expect(page).to have_selector('li', :text => 'Test scope content note')
  end
  
  scenario 'collection search' do
    visit dams_unit_collections_path('tu')
    expect(page).to have_content('Browse by Collection: Test Unit')
    expect(find('#q')['placeholder']).to eq('Search Test Unit')
    expect(page).to have_selector('a', :text => 'Test Bee Collection')

    # search for the collection in the unit and find it
    fill_in 'q', :with => 'Test'
    find('#search-button').click
    expect(page).to have_selector('a', :text => 'Test Bee Collection')
    
    # does not find this collection because it belongs to other unit
    expect(page).to_not have_selector('a', :text => 'Test Collection')
  end
  
  scenario 'Search and browse contextually within a unit' do
    visit dams_unit_collections_path('rdcpt')
    expect(page).to have_content('Browse by Collection: UCSD Research Data Collections Test')
    expect(find('#q')['placeholder']).to eq('Search Research Data Collections Test')
  end     
end
