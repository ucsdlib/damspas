require 'spec_helper'
require 'net/http'
require 'json'

describe DamsObjectsController do
  describe "ezid" do
    it "should call damsrepo to mint DOIs" do
      json = JSON.parse( '{"statusCode":200,
                           "message":"Minted DOI: http://doi.org/10.1234/XX123",
                           "timestamp":"2015-02-04T04:22:19-0500",
                           "request":"\/objects\/bb80808080\/mint_doi",
                           "status":"SUCCESS" }' )
      subject.stub(:dams_post) { @posted = true; json }

      sign_in User.create! ({:provider => 'developer'})
      get :ezid, { id: 'bb80808080' }
      expect(@posted).to be true
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

      sign_in User.create! ({:provider => 'developer'})
      get :ezid, { id: 'bb80808080' }
      flash[:alert].should include "Minting DOI failed"
    end
  end
end
