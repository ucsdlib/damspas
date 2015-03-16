require 'spec_helper'

feature "twitter cards" do
  before(:all) do
    @col = DamsAssembledCollection.create titleValue: "Test Collection", visibility: "public"
    @obj = DamsObject.new pid: 'xx6212468x'
    @obj.damsMetadata.content = File.new('spec/fixtures/damsObjectSample.rdf.xml').read
    @obj.save
    solr_index @obj.pid
    solr_index @col.pid
  end
  after(:all) do
    @obj.delete
    @col.delete
    @unit = DamsUnit.find('xx48484848')
    @unit.delete
    @scope = DamsScopeContentNote.find('xx11111111')
    @scope.delete
  end
  scenario "objects should have meta tags" do
    visit dams_object_path @obj

    # expected metadata
    site = 'UC San Diego Library | Digital Collections'
    title1 = 'Digital Collections: Test Object'
    title2 = 'Test Object'
    desc = "ScopeContentNote value\nNow with linebreaks."
    preview = file_url(@obj,'_3.jpg')

    # twitter card and site info
    page.should have_css 'meta[name="twitter:card"][content="summary"]', :visible => false
    page.should have_css 'meta[name="twitter:site"][content="@ucsdlibrary"]', :visible => false
    page.should have_css 'meta[property="og:site_name"][content="' + site + '"]', :visible => false
    page.should have_css 'meta[property="og:url"][content="' + dams_object_url(@obj) + '"]', :visible => false

    # title and description
    page.should have_css 'meta[name="twitter:title"][content="' + title1 + '"]', :visible => false
    page.should have_css 'meta[property="og:title"][content="' + title2 + '"]', :visible => false
    page.should have_css 'meta[name="twitter:description"][content="' + desc + '"]', :visible => false
    page.should have_css 'meta[property="og:description"][content="' + desc + '"]', :visible => false

    # image preview
    page.should have_css 'meta[name="twitter:image"][content="' + preview + '"]', :visible => false
    page.should have_css 'meta[property="og:image"][content="' + preview + '"]', :visible => false
  end
  scenario "collections should have meta tags" do
    visit dams_collection_path @col

    desc = 'Collection from the UC San Diego Library Digital Collections'
    page.should have_css 'meta[name="twitter:description"][content="' + desc + '"]', :visible => false
    page.should have_css 'meta[property="og:description"][content="' + desc + '"]', :visible => false
  end
end
