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

  describe "an auth_link user" do
    before(:example) do
      @user = create_auth_link_user
    end

    it "should have a valid email" do
      expect(@user.provider).to eq("auth_link")
      expect(@user).to be_valid # validate email format
    end
    it "should have an authentication token" do
      expect(@user.authentication_token).to_not be_nil
    end
    it "should save successfully and correctly" do
      expect{@user.save}.to_not raise_error
      expect(@user.provider).to eq("auth_link") # protect against bug that sets :provider => "developer" on save
    end
    it "should default to having 0 authorized works" do
      expect(@user.work_authorizations.count).to eq(0)
      expect(@user.work_authorizations_count).to eq(0)
    end
    it "should increment a counter when a work is authorized" do
      create_test_dams_object

      expect{@user.work_authorizations.create(work_title: 'test_title', work_pid: 'test_pid')}.to change(@user, :work_authorizations_count).by(1)
      expect(@user.work_authorizations.count).to eq(@user.work_authorizations_count)
    end
    it "should decrement a counter when a work authorization expires" do
      create_test_dams_object
      @user.work_authorizations.create(work_title: 'test_title', work_pid: 'test_pid')

      expect{@user.work_authorizations.last.destroy && @user.reload}.to change(@user, :work_authorizations_count).by(-1)
      expect(@user.work_authorizations.count).to eq(@user.work_authorizations_count)
    end
  end

  describe ".to_s" do
    it "should be the value of the user's user_key" do
      @dev_user = User.first_or_initialize(:uid => "test_user", :provider => "developer")
      @shibboleth_user = User.first_or_initialize(:uid => "test_user", :provider => "shibboleth")
      @auth_link_user = create_auth_link_user

      expect(@dev_user.to_s).to eq(@dev_user.user_key)
      expect(@shibboleth_user.to_s).to eq(@shibboleth_user.user_key)
      expect(@auth_link_user.to_s).to eq(@auth_link_user.user_key)
    end
  end

  describe ".user_key" do
    it "should be the value of the user's uid" do
      @dev_user = User.first_or_initialize(:uid => "test_user", :provider => "developer")
      @shibboleth_user = User.first_or_initialize(:uid => "test_user", :provider => "shibboleth")
      @auth_link_user = create_auth_link_user

      expect(@dev_user.user_key).to eq(@dev_user.uid)
      expect(@shibboleth_user.user_key).to eq(@shibboleth_user.uid)
      expect(@auth_link_user.user_key).to eq(@auth_link_user.uid)
    end
  end

  describe ".to_s" do
    it "should be the value of the user's user_key" do
      @dev_user = User.first_or_initialize(:uid => "test_user", :provider => "developer")
      @shibboleth_user = User.first_or_initialize(:uid => "test_user", :provider => "shibboleth")
      @auth_link_user = create_auth_link_user

      expect(@dev_user.to_s).to eq(@dev_user.user_key)
      expect(@shibboleth_user.to_s).to eq(@shibboleth_user.user_key)
      expect(@auth_link_user.to_s).to eq(@auth_link_user.user_key)
    end
  end

  describe ".user_key" do
    it "should be the value of the user's uid" do
      @dev_user = User.first_or_initialize(:uid => "test_user", :provider => "developer")
      @shibboleth_user = User.first_or_initialize(:uid => "test_user", :provider => "shibboleth")
      @auth_link_user = create_auth_link_user

      expect(@dev_user.user_key).to eq(@dev_user.uid)
      expect(@shibboleth_user.user_key).to eq(@shibboleth_user.uid)
      expect(@auth_link_user.user_key).to eq(@auth_link_user.uid)
    end
  end
end
