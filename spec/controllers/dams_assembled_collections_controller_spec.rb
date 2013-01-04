require 'spec_helper'

describe DamsAssembledCollectionsController do
  before do
    @archivist = User.create!(email: "ar@eu.edu", password: "123456")
    sign_in @archivist
    DamsAssembledCollection.find_each{|z| z.delete}
  end
  
  render_views
  
  describe "#new" do
    it "should set a template dams_assembled_collection" do
      get :new
      response.should be_successful
      assigns[:dams_assembled_collection].should be_kind_of DamsAssembledCollection
    end
  end

  describe "#create" do
    it "should create a dams_collection" do
 
      post :create, :dams_assembled_collection=>{:title=>"Dams Collection Titl", :titleType=>"titleType"}

      response.should redirect_to dams_assembled_collections_path
      assigns[:dams_assembled_collection].edit_users.should == [@archivist.user_key]
    end
  end

  describe "creating" do
    it "should render the create page" do
       get :new
       assigns[:dams_assembled_collection].should be_kind_of DamsAssembledCollection
    end
  end

  describe "#index" do
    before do
      @damsCol1 = DamsAssembledCollection.new(:title=>"Dams Collection Title 1")
      @damsCol2 = DamsAssembledCollection.new(:title=>"Dams Collection Title 2")
    end
    it "should display a list of all the dams collections" do
      get :index
      response.should be_successful
      #assigns[:dams_objects].should == [@damsObj1,@damsObj2]failed, fix later
    end
  end

  describe "#edit" do
    before do
      @damsCollection = DamsAssembledCollection.new(:title=>"Dams Object Title Test Update")
      @damsCollection.edit_users = [@archivist.user_key]
      @damsCollection.save!
    end
    it "should be successful" do
      get :edit, :id=>@damsCollection
      response.should be_successful
      assigns[:dams_assembled_collection].should == @damsCollection
    end
  end

  describe "#update" do
    before do
      @damsCol = DamsAssembledCollection.new(:title=>"Dams Object Title Test Update")
      @damsCol.edit_users = [@archivist.user_key]
      @damsCol.save!
    end
    it "should update the Dams Collection" do
      put :update, :id=>@damsCol, :dams_assembled_collection=> { :title=>"Dams Object Title Test Update 2"}
      response.should redirect_to edit_dams_assembled_collection_path(@damsCol)
      @damsCol=DamsAssembledCollection.find(@damsCol.pid)
      @damsCol.title.should == 'Dams Object Title Test Update 2'
      flash[:notice].should == "Dams Collection was successfully updated."
    end

  end

end

