require 'spec_helper'

describe MadsOccupationsController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:mads_occupation].should be_kind_of MadsOccupation
        assigns[:mads_occupation].occupationElement.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, mads_occupation: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "occupationElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "Occupation has been saved"
        response.should redirect_to mads_occupation_path(assigns[:mads_occupation])

        assigns[:mads_occupation].elementList.size.should == 1

        assigns[:mads_occupation].scheme.first.code.should == ['test']
        assigns[:mads_occupation].scheme.first.name.should == ['Test Scheme']

      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:occupation) { MadsOccupation.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}])}
      after do
        occupation.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: occupation, mads_occupation: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "occupationElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated Occupation"
        response.should redirect_to mads_occupation_path(assigns[:mads_occupation])

        assigns[:mads_occupation].elementList.size.should == 1

        assigns[:mads_occupation].scheme.size.should == 1
        assigns[:mads_occupation].scheme.first.code.should == ['test']
        assigns[:mads_occupation].scheme.first.name.should == ['Test Scheme']

      end
    end
  end

end
