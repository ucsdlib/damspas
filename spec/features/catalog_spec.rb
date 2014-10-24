require 'spec_helper'

feature 'Visitor wants to search' do
  scenario 'is on search results page' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h4', :text => 'Refine your search')
    expect(page).to have_selector('h3', :text => 'Sample Simple Object')
    expect(page).to have_selector("img.dams-search-thumbnail:first")
    expect(page).to have_selector("a.dams-search-thumbnail-link:first")
  end
  scenario 'is on a browse results page' do
    # should show links to remove facets, even when there is no query
    visit catalog_index_path( {'f[unit_sim][]' => 'Library Digital Collections'} )
    expect(page).to have_selector("div.dams-search-constraints")
    expect(page).to have_selector("span.dams-filter")
  end
  scenario 'results sorted by title' do
    sign_in_developer
    visit catalog_index_path( {'q' => 'Dissertations', 'per_page' => 100, 'sort' => 'score desc, system_create_dtsi desc, title_ssi asc'} )
    idx1 = page.body.index('Sample Complex Object Record #1') # subject matched, no date
    idx2 = page.body.index('Chicano and black radical activism of the 1960s: a comparison between the Brown Berets and the Black Panther Party in California')      # subject matched, 2010
    idx3 = page.body.index('Sample Complex Object Record #3')   # collection matched, no date
    idx2.should > idx1
    idx3.should > idx2

    click_on "Sample Complex Object Record #3"
    expect(page).to have_selector('div.search-results-pager')
  end
  scenario 'results sorted by object creation date' do
    sign_in_developer
    visit catalog_index_path( {'f[unit_sim][]' => 'Library Digital Collections', 'per_page' => 100, 'sort' => 'object_create_dtsi asc, title_ssi asc'} )
    idx1 = page.body.index('Sample Audio Object: I need another')  # no date
    idx2 = page.body.index('Sample Complex Object Record #1')      # 1980
    idx3 = page.body.index('Chicano and black radical activism')   # 2010
    idx4 = page.body.index('Sample Simple Object')                 # 2012-04-08
    idx4.should >( idx3 )
    idx3.should >( idx2 )
    idx2.should >( idx1 )

    click_on "Chicano and black radical activism"
    expect(page).to have_selector('div.search-results-pager')
  end
  scenario 'system queries should show search results' do
    visit catalog_index_path( {:fq => ['{!join from=collections_tesim to=id}unit_code_tesim:dlp']} )
    expect(page).to have_selector('ol#dams-search-results li div h3')
  end
#  scenario 'is on search results page for restricted object' do
#    sign_in_developer
#    visit catalog_index_path( {:q => 'women'} )
#    expect(page).to have_selector('h3:first', :text => 'Women wrapping food.')
#    expect(page).to have_selector("img.dams-search-thumbnail:first")
#    expect(page).to have_css("img[src*='thumb-restricted.png']:first")
#  end  
end

feature 'Visitor is on search result page' do
  scenario 'should see the constraints' do
    visit catalog_index_path( {:q => 'fish'} )
    expect(page).to have_selector('span.dams-filter a')
  end
end

feature 'Visitor wants to browse Topic A-Z ' do
  scenario 'is on Browse by Topic page' do
    sign_in_developer
    visit catalog_facet_path("subject_topic_sim", :'facet.sort' => 'index', :'facet.prefix' => 'A')
    
    expect(page).to have_selector('.btn', :text => 'A')
    page.all(:css, '.facet_select').size.should eq(2)
    page.all('.facet_select')[0].text.should include 'Academic dissertations'
    page.all('.facet_select')[1].text.should include 'African Americans--Relations with Mexican Americans--History--20th Century'    
    
    click_on "C"
    expect(page).to have_selector('.btn', :text => 'C')
    page.all(:css, '.facet_select').size.should eq(3)
    page.all('.facet_select')[0].text.should include 'Cosmic background radiation'
    page.all('.facet_select')[1].text.should include 'Cosmology'
    page.all('.facet_select')[2].text.should include 'Cosmology--Observations'   
  end
  
  scenario 'wants to select Numerical Sort' do
    sign_in_developer
    visit catalog_facet_path("subject_topic_sim", :'facet.sort' => 'index', :'facet.prefix' => 'S')
    
    expect(page).to have_selector('.btn', :text => 'S')
    page.all(:css, '.facet_select').size.should eq(2)
    page.all('.facet_select')[0].text.should include 'San Diego Supercomputer Center.'
    page.all('.facet_select')[1].text.should include 'Smith, John, Dr., 1965-'    
    
    click_on("Sort 1-9", match: :first)
    expect(page).to have_selector('.btn', :text => 'S')
    page.all(:css, '.facet_select').size.should eq(2)
    page.all('.facet_select')[0].text.should include 'Smith, John, Dr., 1965-'      
    page.all('.facet_select')[1].text.should include 'San Diego Supercomputer Center.'
  end  
end

feature 'Visitor wants to browse Creator A-Z ' do
  scenario 'is on Browse by Creator page' do
    sign_in_developer
    visit catalog_facet_path("creator_sim", :'facet.sort' => 'index', :'facet.prefix' => 'A')
    
    expect(page).to have_selector('.btn', :text => 'A')
    page.all(:css, '.facet_select').size.should eq(1)
    page.all('.facet_select')[0].text.should include 'Artist, Alice, 1966-'
    
    click_on "B"
    expect(page).to have_selector('.btn', :text => 'B')
    page.all(:css, '.facet_select').size.should eq(1)
    page.all('.facet_select')[0].text.should include 'Burns, Jack O.'
  end
end
