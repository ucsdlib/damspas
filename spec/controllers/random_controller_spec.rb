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
    solr_index @o.pid
  end
  after(:all) do
    @o.delete     
  end

  describe 'GET index' do
    before do
      get :index, {:id => "item"}      
      @items = "#{response.body}"
    end  
    it 'get the random url' do
      get :index
      expect(response.status).to eq( 200 )
      expect(response.header['Content-Type']).to match /json/
      random_obj_id = response.body.to_s[/\w{10}$/]
      expect(@items).to include(random_obj_id)
    end
  end   
end