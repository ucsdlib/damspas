require 'spec_helper'

describe DamsCollectionsController do
  before(:all) do
    @unit = DamsUnit.create name: "Test Unit", description: "Test Description", code: "tu", uri: "http://example.com/"
    @provCollection = DamsProvenanceCollection.create titleValue: "Sample Provenance Collection", visibility: "public"
      @provCollection.save!
      solr_index (@provCollection.pid)
  end
  after(:all) do
    @unit.delete
    @provCollection.delete
  end

  describe "osf_delete" do
    it "should delete a record from SHARE OSF" do
      sign_in User.create({:provider => 'developer'})
      get :osf_delete, { id: @provCollection.pid }
      expect(flash[:notice]).to include "Your record has been deleted from OSF Share."
    end
  end

  describe "share_config" do
    it "should load config file" do
      @controller = DamsCollectionsController.new
      @controller.send(:share_config).fetch('token').should == "share_token"
      @controller.send(:share_config).fetch('host').should == "https://staging-share.osf.io/"
    end
  end
end
