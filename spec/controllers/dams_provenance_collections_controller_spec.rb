require 'spec_helper'

describe DamsProvenanceCollectionsController do
  describe "A login user" do
      before do
          sign_in User.create! ({:provider => 'developer'})
        #DamsProvenanceCollection.find_each{|z| z.delete}
      end
      describe "Show" do
        before do
          @obj = DamsProvenanceCollection.create(titleValue: "Test Provenance Collection Title 1", beginDate: "2012-01-01", endDate: "2013-01-01", visibility: "public", resource_type: "text")
        end
        after do
          @obj.delete
        end
        it "should be successful" do 
          get :show, id: @obj.id
          expect(response.status).to eq(200)
          @newobj = assigns[:dams_provenance_collection]
          expect(@newobj.titleValue).to eq(@obj.titleValue)
          expect(@newobj.beginDate).to eq(@obj.beginDate)
          expect(@newobj.endDate).to eq(@obj.endDate)
          expect(@newobj.visibility).to eq(@obj.visibility)
          expect(@newobj.resource_type).to eq(@obj.resource_type)
        end
      end
  end
end

