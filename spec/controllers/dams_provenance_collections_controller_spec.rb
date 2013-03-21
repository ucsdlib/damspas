require 'spec_helper'

describe DamsProvenanceCollectionsController do
  describe "A login user" do
      before do
          sign_in User.create!
        #DamsProvenanceCollection.find_each{|z| z.delete}
      end
      describe "Show" do
        before do
          @obj = DamsProvenanceCollection.create(title: "Provenance Collection Test Title 1", beginDate: "2012-01-01", endDate: "2013-01-01")
          #puts @obj.id
        end
        it "should be successful" do 
          get :show, id: @obj.id
          response.should be_successful 
          assigns[:dams_provenance_collection].should == @obj
        end
      end
      
      describe "New" do
        it "should be successful" do 
          get :new
          response.should be_successful 
          assigns[:dams_provenance_collection].should be_kind_of DamsProvenanceCollection
        end
      end
      
      describe "Edit" do
        before do
          @obj = DamsProvenanceCollection.create(title: "Provenance Collection Test Title 2", beginDate: "2012-02-02", endDate: "2013-02-02")
        end    
        it "should be successful" do 
          get :edit, id: @obj.id
          response.should be_successful 
          assigns[:dams_provenance_collection].should == @obj
        end
      end
      
      describe "Create" do
        it "should be successful" do
          expect { 
            post :create, :dams_provenance_collection => {title: "Provenance Collection Test Title 3", date: "2013-03-03"}
        }.to change { DamsProvenanceCollection.count }.by(1)
          response.should redirect_to assigns[:dams_provenance_collection]
          assigns[:dams_provenance_collection].should be_kind_of DamsProvenanceCollection
        end
      end
      
      describe "Update" do
        before do
           @obj = DamsProvenanceCollection.create(title: "Provenance Collection Test Title 4", beginDate: "2012-04-04", endDate: "2013-04-04")
         end
        it "should be successful" do
          put :update, :id => @obj.id, :dams_provenance_collection => {title: "Test Title 5", beginDate: "2012-05-05"}
          response.should redirect_to assigns[:dams_provenance_collection]
          #@obj.reload.title.should == ["Test Title 5"]
          flash[:notice].should == "Successfully updated provenance_collection"
          pending "check title after reload #{__FILE__}"
        end
    end
  end
end

