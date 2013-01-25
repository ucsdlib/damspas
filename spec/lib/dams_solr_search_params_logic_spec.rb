require 'spec_helper'

describe Dams::SolrSearchParamsLogic do
  class HelperSubject
    include Dams::SolrSearchParamsLogic
  end

  subject { HelperSubject.new }
  
  describe "#scope_search_to_repository" do
    it "should scope the search to a repository using an fq" do
      repository = mock(:id => 'bXXXXXXX7')
      DamsRepository.stub(:find).and_return(repository) 
      subject.stub(:fq_for_repository => 'zzz')

      params = { :repository => 'bXXXXXXX7'}
      output = {}
      subject.scope_search_to_repository(output, params)

      output[:fq].should include('zzz')
    end
  end

end