require 'spec_helper'

describe Dams::SolrSearchParamsLogic do
  class HelperSubject
    include Dams::SolrSearchParamsLogic
  end

  subject { HelperSubject.new }
  
  describe "#scope_search_to_unit" do
    it "should scope the search to a unit using an fq" do
      unit = mock(:id => 'bXXXXXXX7')
      DamsUnit.stub(:find).and_return(unit) 
      subject.stub(:fq_for_unit => 'zzz')
      subject.stub(:blacklight_config => mock(:unit_id_solr_field => 'unit_id' ))

      params = { :unit => 'bXXXXXXX7'}
      output = {}
      subject.scope_search_to_unit(output, params)

      output[:fq].should include('zzz')
    end
  end

end
