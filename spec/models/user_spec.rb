require 'spec_helper'

describe User do

  describe ".find_or_create_for_developer" do
    it "should create a User for a new patron" do
      token = { 'info' => { 'email' => nil } }
      allow(token).to receive_messages(:uid => "test_user", :provider => "developer")
      user = User.find_or_create_for_developer(token)

      expect(user).to be_persisted
      expect(user.provider).to eq("developer")
      expect(user.uid).to eq("test_user")
      expect(user.groups).to include('developer-authenticated')
    end

    it "should reuse an existing User if the access token matches" do

      token = { 'info' => { 'email' => nil } }
      allow(token).to receive_messages(:uid => "test_user", :provider => "developer")
      user = User.find_or_create_for_developer(token)

      expect { User.find_or_create_for_developer(token) }.not_to change(User, :count) 
    
    end
  end

  describe ".find_or_create_for_shibboleth" do

    it "should create a User when a user is first authenticated" do

      token = { 'info' => { 'email' => nil } }
      allow(token).to receive_messages(:uid => "test_user", :provider => "shibboleth")
      user = User.find_or_create_for_shibboleth(token)

      expect(user).to be_persisted
      expect(user.provider).to eq("shibboleth")
      expect(user.uid).to eq("test_user")
      
      expect(user.groups).to include('shibboleth-authenticated')
    end
  end

  describe "#groups" do
    it "should default to 'unknown'" do
      expect(subject.groups).to eq(['unknown'])
    end
  end
end
