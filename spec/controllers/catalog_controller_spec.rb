require 'spec_helper'

describe CatalogController do
  def assigns_response
    @controller.instance_variable_get("@response")
  end
  before(:all) do
    unit = RDF::Resource.new("#{Rails.configuration.id_namespace}bb02020202")
    @obj = DamsObject.new
    @obj.attributes = {titleValue:"Spellcheck Test", subtitle: "Subtitle Test", beginDate: "2013", unit: unit, copyrightURI: "bd0513099p" }
    @obj.save

    # rights metadata not getting set correctly until reindexing...
    solrizer = Solrizer::Fedora::Solrizer.new
    solrizer.solrize @obj.id
  end
  describe "Blacklight search" do
  
    it "should scope searches to unit" do
      expect(CatalogController).to include(Dams::SolrSearchParamsLogic)
      expect(CatalogController.solr_search_params_logic).to include(:scope_search_to_unit)
    end
  
    it "should have search results for an appropriately poor query" do
      get :index, :q => 'Spellchecl', :qf => 'title_tesim'
      assigns_response.docs.size.should > 0
    end

    it "should have a spelling suggestion for an appropriately poor query" do
      get :index, :q => 'spellchecks', :qf => 'title_tesim'
      assigns_response.spelling.words.size.should > 0
    end
 
    it "should have search results for a poor query with multiple key words" do
      get :index, :q => '"Spellchecl Testx"', :qf => 'title_tesim'
      assigns_response.docs.size.should > 0
    end
  
    it "should have a collation phrase spelling suggestion for a poor query with multiple key words" do
      get :index, :q => '"Spellchecl Testx"', :qf => 'title_tesim', 'spellcheck.q' => '"Spellchecl Testx"'
      assigns_response.params[:q].downcase.should == '"spellcheck test"'
    end

  end
end
