require 'spec_helper'

describe DamsLicensesController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:dams_license].should be_kind_of DamsLicense
        assigns[:dams_license].permission_node.size.should == 1
        assigns[:dams_license].restriction_node.size.should == 1
      end
    end

    describe "#create" do
      it "should set the attributes" do
        post :create, dams_license: {"note"=>"note", "uri"=>"http://b.com", "permission_node_attributes"=>{"0"=>{"type"=>"display","beginDate"=>"2013","endDate"=>"2014"}}}
        flash[:notice].should == "License has been saved"
        response.should redirect_to dams_license_path(assigns[:dams_license])

        assigns[:dams_license].permission_node.size.should == 1
        assigns[:dams_license].permission_node.first.beginDate.should == ['2013']
        assigns[:dams_license].permission_node.first.endDate.should == ['2014']
      end
    end

    describe "#update" do
      let!(:license) { DamsLicense.create(permission_node_attributes: [{"beginDate"=>"2013"}])}
      after do
        license.destroy 
      end

      it "should set the attributes" do
        put :update, id: license, dams_license: {"note"=>"note", "uri"=>"http://b.com", "permission_node_attributes"=>{"0"=>{"type"=>"display","beginDate"=>"2014","endDate"=>"2014"}}}
        flash[:notice].should == "Successfully updated License"
        response.should redirect_to dams_license_path(assigns[:dams_license])

        assigns[:dams_license].permission_node.size.should == 1
        assigns[:dams_license].permissionBeginDate.should == ['2014']
      end
    end
  end

end
