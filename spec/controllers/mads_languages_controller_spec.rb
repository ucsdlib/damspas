require 'spec_helper'

describe MadsLanguagesController do
  before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:mads_language].should be_kind_of MadsLanguage
        assigns[:mads_language].languageElement.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, mads_language: {"name"=>"TestLabel", "code"=>"testCode", "externalAuthority"=>"http://test.com", "languageElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "Language has been saved"
        response.should redirect_to mads_language_path(assigns[:mads_language])

        assigns[:mads_language].elementList.size.should == 1

        assigns[:mads_language].scheme.first.code.should == ['test']
        assigns[:mads_language].scheme.first.name.should == ['Test Scheme']

      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:language) { MadsLanguage.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}])}
      after do
        language.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: language, mads_language: {"name"=>"TestLabel", "code"=>"testCode", "externalAuthority"=>"http://test.com", "languageElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated Language"
        response.should redirect_to mads_language_path(assigns[:mads_language])

        assigns[:mads_language].elementList.size.should == 1

        assigns[:mads_language].scheme.size.should == 1
        assigns[:mads_language].scheme.first.code.should == ['test']
        assigns[:mads_language].scheme.first.name.should == ['Test Scheme']

      end
    end
  end

end

