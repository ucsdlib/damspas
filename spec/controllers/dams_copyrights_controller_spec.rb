require 'spec_helper'

describe DamsCopyrightsController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:dams_copyright].should be_kind_of DamsCopyright
        assigns[:dams_copyright].date.size.should == 1
      end
    end

    describe "#create" do
      it "should set the attributes" do
        post :create, dams_copyright: {"status"=>"TestStatus", "jurisdiction"=>"testJurisdiction", "date_attributes"=>{"0"=>{"beginDate"=>"2013"}}}
        flash[:notice].should == "Copyright has been saved"
        response.should redirect_to dams_copyright_path(assigns[:dams_copyright])

        assigns[:dams_copyright].date.size.should == 1
        assigns[:dams_copyright].date.first.beginDate.should == ['2013']
      end
    end

    describe "#update" do
      let!(:copyright) { DamsCopyright.create(date_attributes: [{"beginDate"=>"2013"}])}
      after do
        copyright.destroy 
      end

      it "should set the attributes" do
        put :update, id: copyright, dams_copyright: {"status"=>"TestStatus", "jurisdiction"=>"testJurisdiction", "date_attributes"=>{"0"=>{"beginDate"=>"2013"}}}
        flash[:notice].should == "Successfully updated Copyright"
        response.should redirect_to dams_copyright_path(assigns[:dams_copyright])

        assigns[:dams_copyright].date.size.should == 1
        assigns[:dams_copyright].beginDate.should == ['2013']
      end
    end
  end

end
