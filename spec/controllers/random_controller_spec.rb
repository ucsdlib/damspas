require 'spec_helper'
require 'net/http'
require 'json'

describe RandomController do
  before(:all) do
    @o = DamsObject.create titleValue: 'Test Title',
               subtitle: 'Test Subtitle', titleNonSort: 'The',
               titlePartName: 'Test Part', titlePartNumber: 'Test Number',
               titleTranslationVariant: 'Test Translation Variant',
               copyright_attributes: [{status: 'Public domain'}]
    @other_o = DamsObject.create titleValue: 'Test Title 2',
               subtitle: 'Test Subtitle', titleNonSort: 'The',
               titlePartName: 'Test Part', titlePartNumber: 'Test Number',
               titleTranslationVariant: 'Test Translation Variant',
               copyright_attributes: [{status: 'Public domain'}]
    @acol = DamsAssembledCollection.create( titleValue: 'Test Assembled Collection',
                  visibility: 'public' )
    @pcol = DamsProvenanceCollection.create( titleValue: 'Test Provenance Collection',
                  visibility: 'public' )                              
    solr_index @o.pid
    solr_index @other_o.pid
    solr_index @acol.pid
    solr_index @pcol.pid
  end
  after(:all) do
    @o.delete
    @other_o.delete
    @acol.delete
    @pcol.delete      
  end

  describe 'GET index' do
    before do
      get :show, {:id => "item"}      
      @items = "#{response.body}"
    end  
    it 'get the random url' do
      get :index
      expect(response.status).to eq( 200 )
      response.header['Content-Type'].should match /json/
      
      random_obj_id = response.body.to_s[/\w{10}$/]
      expect(@items).to include(random_obj_id)
    end
  end   
end