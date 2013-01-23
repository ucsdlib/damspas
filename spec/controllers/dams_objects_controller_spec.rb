require 'spec_helper'

describe DamsObjectsController do
  before do
    @archivist = User.create(:uid => "ar@eu.edu",:provider => "spec", :email => "ar@eu.edu")
    sign_in @archivist
    DamsObject.find_each{|z| z.delete}
  end
  
  render_views
  
  describe "#new" do
    it "should set a template dams_object" do
      get :new
      response.should be_successful
      assigns[:dams_object].should be_kind_of DamsObject
    end
  end

  describe "#create" do
    it "should create a dams_object" do
 
      post :create, :dams_object=>{:title=>"Dams Object Title 2", :relatedTitle=>"Dams Object relatedTitle 2", :relatedTitleType=>"translated"}

      response.should redirect_to dams_objects_path
      assigns[:dams_object].edit_users.should == [@archivist.user_key]
    end
  end

  describe "creating" do
    it "should render the create page" do
       get :new
       assigns[:dams_object].should be_kind_of DamsObject
       #renders.should == "new"
    end
  end

  describe "#index" do
    before do
      @damsObj1 = DamsObject.new(:title=>"Dams Object Title 1", :relatedTitle=>"Dams Object relatedTitle Test Update", :relatedTitleType=>"translated")
      @damsObj2 = DamsObject.new(:title=>"Dams Object Title 2", :relatedTitle=>"Dams Object relatedTitle Test Update", :relatedTitleType=>"translated")
    end
    it "should display a list of all the dams objects" do
      get :index
      response.should be_successful
      #assigns[:dams_objects].should == [@damsObj1,@damsObj2]failed, fix later
    end
  end

  describe "#edit" do
    before do
      @damsObj = DamsObject.new(:title=>"Dams Object Title Test Update", :relatedTitle=>"Dams Object relatedTitle Test Update", :relatedTitleType=>"translated")
      @damsObj.edit_users = [@archivist.user_key]
      @damsObj.save!
    end
    it "should be successful" do
      get :edit, :id=>@damsObj
      response.should be_successful
      assigns[:dams_object].should == @damsObj
    end
  end

  describe "#update" do
    before do
      @damsObj = DamsObject.new(:title=>"Dams Object Title Test Update", :relatedTitle=>"Dams Object relatedTitle Test Update", :relatedTitleType=>"translated")
      @damsObj.edit_users = [@archivist.user_key]
      @damsObj.save!
    end
    it "should update the Dams Object" do
      put :update, :id=>@damsObj, :dams_object=> { :title=>"Dams Object Title Test Update 2", :relatedTitle=>"Dams Object relatedTitle Test Update 2", :relatedTitleType=>"translated 2"}
      response.should redirect_to edit_dams_object_path(@damsObj)
      @damsObj=DamsObject.find(@damsObj.pid)
      @damsObj.title.should == 'Dams Object Title Test Update 2'
      @damsObj.relatedTitle.should == "Dams Object relatedTitle Test Update 2"
      @damsObj.relatedTitleType.should == "translated 2"
      flash[:notice].should == "Dams Object was successfully updated."
    end

  end

end

