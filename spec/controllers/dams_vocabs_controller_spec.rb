require 'spec_helper'

describe DamsVocabsController do
  before do
    @archivist = User.create!(email: "ar@eu.edu", password: "123456")
    sign_in @archivist
    DamsVocab.find_each{|z| z.delete}
  end
  
  render_views
  
  describe "#new" do
    it "should set a template dams_vocab" do
      get :new
      response.should be_successful
      assigns[:dams_vocab].should be_kind_of DamsVocab
    end
  end

  describe "#create" do
    it "should create a dams_vocab" do
 
      post :create, :dams_vocab=>{:vocabDesc=>"Language"}

      response.should redirect_to dams_vocabs_path
      assigns[:dams_vocab].edit_users.should == [@archivist.user_key]
    end
  end

  describe "creating" do
    it "should render the create page" do
       get :new
       assigns[:dams_vocab].should be_kind_of DamsVocab
       #renders.should == "new"
    end
  end

  describe "#index" do
    before do
      @damsVocab1 = DamsVocab.new(:vocabDesc=>"Language")
      @damsVocab2 = DamsVocab.new(:vocabDesc=>"Language")
    end
    it "should display a list of all the dams objects" do
      get :index
      response.should be_successful
    end
  end

  describe "#edit" do
    before do
      @damsVocab = DamsVocab.new(:vocabDesc=>"Language")
      @damsVocab.edit_users = [@archivist.user_key]
      @damsVocab.save!
    end
    it "should be successful" do
      get :edit, :id=>@damsVocab
      response.should be_successful
      assigns[:dams_vocab].should == @damsVocab
    end
  end

  describe "#update" do
    before do
      @damsVocab = DamsVocab.new(:vocabDesc=>"Language")    
      @damsVocab.edit_users = [@archivist.user_key]
      @damsVocab.save!
    end
    it "should update the Dams Vocab" do
      put :update, :id=>@damsVocab, :dams_vocab=> { :vocabDesc=>"Language 2"}
      response.should redirect_to edit_dams_vocab_path(@damsVocab)
      @damsVocab=DamsVocab.find(@damsVocab.pid)
      @damsVocab.vocabDesc.should == 'Language 2'
      flash[:notice].should == "Dams Vocab was successfully updated."
    end

  end

end

