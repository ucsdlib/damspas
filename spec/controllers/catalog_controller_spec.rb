require 'spec_helper'

describe CatalogController do
  def assigns_response
      @controller.instance_variable_get("@response")
  end
	
  it "should scope searches to unit" do
    expect(CatalogController).to include(Dams::SolrSearchParamsLogic)
    expect(CatalogController.solr_search_params_logic).to include(:scope_search_to_unit)
  end
  
  describe "Did You Mean spelling suggestion for an appropriately poor query" do
	
	before do
		sign_in User.create!
		@obj = DamsObject.create(titleValue: "Spellcheck Test", subtitle: "Subtitle Test", beginDate: "2012")
	end
	it "should have search results for an appropriately poor query" do
		get :index, :q => 'Spellchecl', :qf => 'title_tesim'
		assigns_response.docs.size.should > 0
	end
	it "should have a spelling suggestion for an appropriately poor query" do
		get :index, :q => 'Spellchecl', :qf => 'title_tesim', 'spellcheck.q' => '"Spellchecl"'
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
