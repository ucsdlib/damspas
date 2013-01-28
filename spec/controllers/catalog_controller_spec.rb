require 'spec_helper'

describe CatalogController do
  it "should scope searches to repositories" do
    expect(CatalogController).to include(Dams::SolrSearchParamsLogic)
    expect(CatalogController.solr_search_params_logic).to include(:scope_search_to_repository)
  end
end