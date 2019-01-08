require 'spec_helper'
require 'net/http'
require 'json'

describe DamsObjectsController do
  before(:all) do
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/" 
    @copy = DamsCopyright.create status: 'Public domain'
    @obj = DamsObject.create titleValue: "Spellcheck Test", subtitle: "Subtitle Test", beginDate: "2013", unitURI: @unit.pid, copyrightURI: @copy.pid
    @obj2 = DamsObject.create titleValue: "Test Record #2", unitURI: @unit.pid, copyrightURI: @copy.pid
    solr_index @obj.pid
  end
  after(:all) do
    @obj.delete
    @obj2.delete
    @copy.delete
    @unit.delete
  end

  describe "ezid" do
    it "should call damsrepo to mint DOIs" do
      json = JSON.parse( '{"statusCode":200,
                           "message":"Minted DOI: http://doi.org/10.1234/XX123",
                           "timestamp":"2015-02-04T04:22:19-0500",
                           "request":"\/objects\/bb80808080\/mint_doi",
                           "status":"SUCCESS" }' )
      allow(subject).to receive(:dams_post).and_return(json)
      allow(subject).to receive(:authorize!).and_return(true)

      sign_in User.create({:provider => 'developer'})
      get :ezid, { id: @obj.pid }
      expect(flash[:notice]).to include "DOI minted"
    end
    it "should should report error when minting DOI fails" do
      json = JSON.parse( '{"statusCode":500,
                           "message":"Error minting DOI",
                           "exception":"stacktrace here",
                           "timestamp":"2015-02-04T04:22:19-0500",
                           "request":"\/objects\/bb80808080\/mint_doi",
                           "status":"ERROR"}' )
      allow(subject).to receive(:dams_post) { json }
      allow(subject).to receive(:authorize!).and_return(true)

      sign_in User.create! ({:provider => 'developer'})
      get :ezid, { id: @obj.pid }
      expect(flash[:alert]).to include "Minting DOI failed"
    end
  end

  describe "ezid_update" do
    it "should call damsrepo to update DOI" do
      json = JSON.parse( '{"statusCode":200,
                           "message":"Updated DOI: http://doi.org/10.1234/XX123",
                           "timestamp":"2015-02-04T04:22:19-0500",
                           "request":"\/objects\/bb80808080\/update_doi",
                           "status":"SUCCESS" }' )
      allow(subject).to receive(:dams_post).and_return(json)
      allow(subject).to receive(:authorize!).and_return(true)

      sign_in User.create({:provider => 'developer'})
      get :ezid_update, { id: @obj.pid }
      expect(flash[:notice]).to include "DOI updated"
    end
    it "should should report error when minting DOI fails" do
      json = JSON.parse( '{"statusCode":500,
                           "message":"Error updating DOI",
                           "exception":"stacktrace here",
                           "timestamp":"2015-02-04T04:22:19-0500",
                           "request":"\/objects\/bb80808080\/update_doi",
                           "status":"ERROR"}' )
      allow(subject).to receive(:dams_post) { json }
      allow(subject).to receive(:authorize!).and_return(true)

      sign_in User.create! ({:provider => 'developer'})
      get :ezid_update, { id: @obj.pid }
      expect(flash[:alert]).to include "Updating DOI failed"
    end
  end

  describe "search results counter" do
    it "should redirect requests with a counter param" do
      ref = 'http://test.host/search?q=test'
      @request.env['HTTP_REFERER'] = ref
      get :show, { id: @obj.pid, counter: 1 }
      expect(response.status).to eq( 302 )
      expect(response).to redirect_to action: :show, id: @obj.pid
      expect(session[:search_results]).to eq(ref)
    end
    it "should handle pages with external referrers" do
      ref = 'https://www.google.com/search?q=foo'
      @request.env['HTTP_REFERER'] = ref
      get :show, { id: @obj.pid }
      expect(response.status).to eq( 200 )
      expect(session[:search_results]).to be_nil
    end
    it "should handle pages with referrers from other internal urls" do
      ref = 'https://test.host/foo'
      @request.env['HTTP_REFERER'] = ref
      get :show, { id: @obj.pid }
      expect(response.status).to eq( 200 )
      expect(session[:search_results]).to be_nil
    end
  end
end
