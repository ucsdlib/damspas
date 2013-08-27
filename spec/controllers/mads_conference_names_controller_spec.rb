require 'spec_helper'

describe MadsConferenceNamesController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:mads_conference_name].should be_kind_of MadsConferenceName
        assigns[:mads_conference_name].fullNameElement.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, mads_conference_name: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "fullNameElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "ConferenceName has been saved"
        response.should redirect_to mads_conference_name_path(assigns[:mads_conference_name])

        assigns[:mads_conference_name].elementList.size.should == 1

        assigns[:mads_conference_name].scheme.first.code.should == ['test']
        assigns[:mads_conference_name].scheme.first.name.should == ['Test Scheme']
      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:conference_name) { MadsConferenceName.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}],fullNameElement_attributes: [{ elementValue: "Burns" }],
      givenNameElement_attributes: [{ elementValue: "Jack O." }])}
      after do
        conference_name.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: conference_name, mads_conference_name: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "fullNameElement_attributes"=>{"0"=>{"elementValue"=>"BaseBall"}}, "givenNameElement_attributes"=>{"0"=>{"elementValue"=>"given Name value"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated ConferenceName"
        response.should redirect_to mads_conference_name_path(assigns[:mads_conference_name])

        assigns[:mads_conference_name].elementList.size.should == 2
		assigns[:mads_conference_name].elementList[0].elementValue.should == "BaseBall"
		assigns[:mads_conference_name].elementList[1].elementValue.should == "given Name value"
		assigns[:mads_conference_name].fullNameValue.should == "BaseBall"
		assigns[:mads_conference_name].givenNameValue.should == "given Name value"
				
        assigns[:mads_conference_name].scheme.size.should == 1
        assigns[:mads_conference_name].scheme.first.code.should == ['test']
        assigns[:mads_conference_name].scheme.first.name.should == ['Test Scheme']
      end
    end
  end

end
