require 'spec_helper'

describe DamsOtherRightsController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:dams_other_right].should be_kind_of DamsOtherRight
        assigns[:dams_other_right].permission_node.size.should == 1
        assigns[:dams_other_right].restriction_node.size.should == 1
      end
    end

    describe "#create" do
	  let!(:role) { MadsAuthority.create!(name: 'Authority Role Test') }
	  let!(:name) { MadsName.create!(name: 'Test Name') }
	
	  after do
	    role.destroy
	    name.destroy
	  end    
      it "should set the attributes" do
      	puts role.pid
        #post :create, dams_other_right: {"note"=>"TestNote", "permission_node_attributes"=>{"0"=>{"beginDate"=>"2013"}}}
        post :create, dams_other_right: {"note"=>"TestNote", "permission_node_attributes"=>{"0"=>{"beginDate"=>"2013"}},"role"=>["#{role.pid}"],"name"=>["#{name.pid}"]}
        flash[:notice].should == "OtherRights has been saved"
        response.should redirect_to dams_other_right_path(assigns[:dams_other_right])

        assigns[:dams_other_right].permission_node.size.should == 1
        assigns[:dams_other_right].permission_node.first.beginDate.should == ['2013']
      end
    end

    describe "#update" do
	  let!(:role) { MadsAuthority.create!(name: 'Authority Role Test') }
	  let!(:name) { MadsName.create!(name: 'Test Name') }    
	  let!(:role2) { MadsAuthority.create!(name: 'Authority Role Test2') }
	  let!(:name2) { MadsName.create!(name: 'Test Name2') } 	  
      let!(:other_right) { DamsOtherRight.create(permission_node_attributes: [{"beginDate"=>"2013"}], role: ["#{role.pid}"], name: ["#{name.pid}"])}
      after do
        other_right.destroy
	    role.destroy
	    name.destroy
	    role2.destroy
	    name2.destroy 	             
      end

      it "should set the attributes" do
        put :update, id: other_right, dams_other_right: {"note"=>"TestNote", "permission_node_attributes"=>{"0"=>{"beginDate"=>"2013"}},"role"=>["#{role2.pid}"],"name"=>["#{name2.pid}"]}
        flash[:notice].should == "Successfully updated OtherRights"
        response.should redirect_to dams_other_right_path(assigns[:dams_other_right])

        assigns[:dams_other_right].permission_node.size.should == 1
        assigns[:dams_other_right].permission_node.first.beginDate.should == ['2013']
        
        assigns[:dams_other_right].relationship.first.loadRole.name.should == ['Authority Role Test2']
        assigns[:dams_other_right].relationship.first.load.name.should == ['Test Name2']
      end
    end
  end

end
