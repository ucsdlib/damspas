require 'spec_helper'
require 'net/http'
require 'json'

describe RandomController do
  describe 'GET index' do
    it 'get the random url' do
      @o = DamsObject.create titleValue: 'Test Title',
               subtitle: 'Test Subtitle', titleNonSort: 'The',
               titlePartName: 'Test Part', titlePartNumber: 'Test Number',
               titleTranslationVariant: 'Test Translation Variant',
               copyright_attributes: [{status: 'Public domain'}]
      solr_index @o.pid
      solr_params = {:qf=>'title_tesim^99', :fq=>'read_access_group_ssim:public', :rows=>100, :fl=>'id'}
      @items = find_solr_records '*:*', solr_params          
      get :index
      expect(response.status).to eq( 200 )
      expect(response.header['Content-Type']).to match /json/
      random_obj_id = response.body.to_s[/\w{10}$/]
      expect(@items).to include(random_obj_id)
      @o.delete
    end
  end   
end