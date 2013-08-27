require 'spec_helper'

describe MadsComplexSubjectsController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:mads_complex_subject].should be_kind_of MadsComplexSubject
        assigns[:mads_complex_subject].componentList.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, mads_complex_subject: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "topic_attributes"=>{"0"=>{"name"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "ComplexSubject has been saved"
        response.should redirect_to mads_complex_subject_path(assigns[:mads_complex_subject])

        assigns[:mads_complex_subject].componentList.size.should == 1

        assigns[:mads_complex_subject].scheme.first.code.should == ['test']
        assigns[:mads_complex_subject].scheme.first.name.should == ['Test Scheme']

      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:complex_subject) { MadsComplexSubject.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}])}
      after do
        complex_subject.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: complex_subject, mads_complex_subject: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "topic_attributes"=>{"0"=>{"name"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated ComplexSubject"
        response.should redirect_to mads_complex_subject_path(assigns[:mads_complex_subject])

        assigns[:mads_complex_subject].componentList.size.should == 1
		assigns[:mads_complex_subject].componentList[0].name.should == ["Baseball"]

        assigns[:mads_complex_subject].scheme.size.should == 1
        assigns[:mads_complex_subject].scheme.first.code.should == ['test']
        assigns[:mads_complex_subject].scheme.first.name.should == ['Test Scheme']

      end
    end
  end

end
