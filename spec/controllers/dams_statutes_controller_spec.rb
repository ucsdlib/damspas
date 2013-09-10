require 'spec_helper'

describe DamsStatutesController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:dams_statute].should be_kind_of DamsStatute
        assigns[:dams_statute].permission_node.size.should == 1
        assigns[:dams_statute].restriction_node.size.should == 1
      end
    end

    describe "#create" do
      it "should set the attributes" do
        post :create, dams_statute: {"note"=>"note", "permission_node_attributes"=>{"0"=>{"type"=>"display","beginDate"=>"2013","endDate"=>"2014"}}}
        flash[:notice].should == "Statute has been saved"
        response.should redirect_to dams_statute_path(assigns[:dams_statute])

        assigns[:dams_statute].permission_node.size.should == 1
        assigns[:dams_statute].permission_node.first.beginDate.should == ['2013']
        assigns[:dams_statute].permission_node.first.endDate.should == ['2014']
      end
    end

    describe "#update" do
      let!(:statute) { DamsStatute.create(permission_node_attributes: [{"beginDate"=>"2013"}])}
      after do
        statute.destroy 
      end

      it "should set the attributes" do
        put :update, id: statute, dams_statute: {"note"=>"note", "permission_node_attributes"=>{"0"=>{"type"=>"display","beginDate"=>"2014","endDate"=>"2014"}}}
        flash[:notice].should == "Successfully updated Statute"
        response.should redirect_to dams_statute_path(assigns[:dams_statute])

        assigns[:dams_statute].permission_node.size.should == 1
        assigns[:dams_statute].permissionBeginDate.should == ['2014']
      end
    end
  end

end
