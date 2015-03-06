require 'spec_helper'
require 'net/http'
require 'json'

describe DamsObjectsController do
  before(:all) do
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/" 
    @copy = DamsCopyright.create 
    @obj = DamsObject.create titleValue: "Spellcheck Test", subtitle: "Subtitle Test", beginDate: "2013", unitURI: @unit.pid, copyrightURI: @copy.pid
  end
  after(:all) do
    @obj.delete
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
      subject.stub(:dams_post).and_return(json)
      subject.stub(:authorize!).and_return(true)

      sign_in User.create({:provider => 'developer'})
      get :ezid, { id: @obj.pid }
      flash[:notice].should include "DOI minted"
    end
    it "should should report error when minting DOI fails" do
      json = JSON.parse( '{"statusCode":500,
                           "message":"Error minting DOI",
                           "exception":"stacktrace here",
                           "timestamp":"2015-02-04T04:22:19-0500",
                           "request":"\/objects\/bb80808080\/mint_doi",
                           "status":"ERROR"}' )
      subject.stub(:dams_post) { json }
      subject.stub(:authorize!).and_return(true)

      sign_in User.create! ({:provider => 'developer'})
      get :ezid, { id: @obj.pid }
      flash[:alert].should include "Minting DOI failed"
    end
  end
end
