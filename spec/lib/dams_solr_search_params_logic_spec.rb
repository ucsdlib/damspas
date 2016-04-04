require 'spec_helper'

describe Dams::SolrSearchParamsLogic do
  class HelperSubject
    include Dams::SolrSearchParamsLogic
  end

  subject { HelperSubject.new }
  
  describe "#scope_search_to_unit" do
    it "should scope the search to a unit using an fq" do
      unit = double(:id => 'bXXXXXXX7')
      allow(DamsUnit).to receive(:find).and_return(unit) 
      allow(subject).to receive_messages(:fq_for_unit => 'zzz')
      allow(subject).to receive_messages(:blacklight_config => double(:unit_id_solr_field => 'unit_id' ))

      params = { :unit => 'bXXXXXXX7'}
      output = {}
      subject.scope_search_to_unit(output, params)

      expect(output[:fq]).to include('zzz')
    end
  end

end
