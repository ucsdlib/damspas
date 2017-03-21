require 'spec_helper'

describe DamsCollectionsController do
  describe "share_config" do
    it "should load config file" do
      @controller = DamsCollectionsController.new
      @controller.send(:share_config).fetch('token').should == "share_token"  
      @controller.send(:share_config).fetch('host').should == "https://staging.osf.io/"  
    end
  end 
end