require 'spec_helper'

describe DamsIconographiesController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:dams_iconography].should be_kind_of DamsIconography
        assigns[:dams_iconography].iconographyElement.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, dams_iconography: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "iconographyElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "iconography has been saved"
        response.should redirect_to dams_iconography_path(assigns[:dams_iconography])

        assigns[:dams_iconography].elementList.size.should == 1

        assigns[:dams_iconography].scheme.first.code.should == ['test']
        assigns[:dams_iconography].scheme.first.name.should == ['Test Scheme']

      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:iconography) { DamsIconography.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}])}
      after do
        iconography.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: iconography, dams_iconography: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "iconographyElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated iconography"
        response.should redirect_to dams_iconography_path(assigns[:dams_iconography])

        assigns[:dams_iconography].elementList.size.should == 1

        assigns[:dams_iconography].scheme.size.should == 1
        assigns[:dams_iconography].scheme.first.code.should == ['test']
        assigns[:dams_iconography].scheme.first.name.should == ['Test Scheme']

      end
    end
  end

end
