require 'spec_helper'

describe User do

  describe ".find_or_create_for_developer" do
    it "should create a User for a new patron" do
      token = { 'info' => { 'email' => nil } }
      token.stub(:uid => "test_user", :provider => "developer")
      user = User.find_or_create_for_developer(token)

      user.should be_persisted
      user.provider.should == "developer"
      user.uid.should == "test_user"
      user.groups.should include('developer-authenticated')
    end

    it "should reuse an existing User if the access token matches" do

      token = { 'info' => { 'email' => nil } }
      token.stub(:uid => "test_user", :provider => "developer")
      user = User.find_or_create_for_developer(token)

      lambda { User.find_or_create_for_developer(token) }.should_not change(User, :count) 
    
    end
  end

  describe ".find_or_create_for_shibboleth" do

    it "should create a User when a user is first authenticated" do

      token = { 'info' => { 'email' => nil } }
      token.stub(:uid => "test_user", :provider => "shibboleth")
      user = User.find_or_create_for_shibboleth(token)

      user.should be_persisted
      user.provider.should == "shibboleth"
      user.uid.should == "test_user"
      
      user.groups.should include('shibboleth-authenticated')
    end
  end

  describe "#groups" do
    it "should default to an empty list" do
      subject.groups.should == []
    end
  end
end
