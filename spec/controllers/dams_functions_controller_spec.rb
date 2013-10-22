require 'spec_helper'

describe DamsFunctionsController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:dams_function].should be_kind_of DamsFunction
        assigns[:dams_function].functionElement.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, dams_function: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "functionElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "function has been saved"
        response.should redirect_to dams_function_path(assigns[:dams_function])

        assigns[:dams_function].elementList.size.should == 1

        assigns[:dams_function].scheme.first.code.should == ['test']
        assigns[:dams_function].scheme.first.name.should == ['Test Scheme']

      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:function) { DamsFunction.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}])}
      after do
        function.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: function, dams_function: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "functionElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated function"
        response.should redirect_to dams_function_path(assigns[:dams_function])

        assigns[:dams_function].elementList.size.should == 1

        assigns[:dams_function].scheme.size.should == 1
        assigns[:dams_function].scheme.first.code.should == ['test']
        assigns[:dams_function].scheme.first.name.should == ['Test Scheme']

      end
    end
  end

end
