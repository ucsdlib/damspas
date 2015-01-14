require 'spec_helper'

feature "twitter cards" do
  scenario "should have meta tags" do
    obj = 'bd22194583'
    visit dams_object_path obj

    # expected metadata
    site = 'UC San Diego Library | Digital Collections'
    title1 = 'Digital Collections: Sample Simple Object'
    title2 = 'Sample Simple Object'
    desc = "ScopeContentNote value\nNow with linebreaks."
    preview = file_url(obj,'3.jpg')

    # twitter card and site info
    page.should have_css 'meta[name="twitter:card"][content="summary"]', :visible => false
    page.should have_css 'meta[name="twitter:site"][content="@ucsdlibrary"]', :visible => false
    page.should have_css 'meta[property="og:site_name"][content="' + site + '"]', :visible => false
    page.should have_css 'meta[property="og:url"][content="' + dams_object_url(obj) + '"]', :visible => false

    # title and description
    page.should have_css 'meta[name="twitter:title"][content="' + title1 + '"]', :visible => false
    page.should have_css 'meta[property="og:title"][content="' + title2 + '"]', :visible => false
    page.should have_css 'meta[name="twitter:description"][content="' + desc + '"]', :visible => false
    page.should have_css 'meta[property="og:description"][content="' + desc + '"]', :visible => false

    # image preview
    page.should have_css 'meta[name="twitter:image"][content="' + preview + '"]', :visible => false
    page.should have_css 'meta[property="og:image"][content="' + preview + '"]', :visible => false
  end
end
