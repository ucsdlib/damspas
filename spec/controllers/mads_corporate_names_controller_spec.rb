require 'spec_helper'

describe MadsCorporateNamesController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:mads_corporate_name].should be_kind_of MadsCorporateName
        assigns[:mads_corporate_name].fullNameElement.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, mads_corporate_name: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "fullNameElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "CorporateName has been saved"
        response.should redirect_to mads_corporate_name_path(assigns[:mads_corporate_name])

        assigns[:mads_corporate_name].elementList.size.should == 1

        assigns[:mads_corporate_name].scheme.first.code.should == ['test']
        assigns[:mads_corporate_name].scheme.first.name.should == ['Test Scheme']
      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:corporate_name) { MadsCorporateName.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}],fullNameElement_attributes: [{ elementValue: "Burns" }],
      givenNameElement_attributes: [{ elementValue: "Jack O." }])}
      after do
        corporate_name.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: corporate_name, mads_corporate_name: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "fullNameElement_attributes"=>{"0"=>{"elementValue"=>"BaseBall"}}, "givenNameElement_attributes"=>{"0"=>{"elementValue"=>"given Name value"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated CorporateName"
        response.should redirect_to mads_corporate_name_path(assigns[:mads_corporate_name])

        assigns[:mads_corporate_name].elementList.size.should == 2
        puts assigns[:mads_corporate_name].elementList[0].class
		assigns[:mads_corporate_name].elementList[0].elementValue.should == ["BaseBall"]
		assigns[:mads_corporate_name].elementList[1].elementValue.should == ["given Name value"]
		assigns[:mads_corporate_name].fullNameValue.should == "BaseBall"
		assigns[:mads_corporate_name].givenNameValue.should == "given Name value"
				
        assigns[:mads_corporate_name].scheme.size.should == 1
        assigns[:mads_corporate_name].scheme.first.code.should == ['test']
        assigns[:mads_corporate_name].scheme.first.name.should == ['Test Scheme']
      end
    end
  end

end
