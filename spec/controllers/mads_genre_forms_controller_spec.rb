require 'spec_helper'

describe MadsGenreFormsController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:mads_genre_form].should be_kind_of MadsGenreForm
        assigns[:mads_genre_form].genreFormElement.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, mads_genre_form: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "genreFormElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "GenreForm has been saved"
        response.should redirect_to mads_genre_form_path(assigns[:mads_genre_form])

        assigns[:mads_genre_form].elementList.size.should == 1

        assigns[:mads_genre_form].scheme.first.code.should == ['test']
        assigns[:mads_genre_form].scheme.first.name.should == ['Test Scheme']

      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme 2')}
      let!(:genre_form) { MadsGenreForm.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}])}
      after do
        genre_form.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: genre_form, mads_genre_form: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "genreFormElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated GenreForm"
        response.should redirect_to mads_genre_form_path(assigns[:mads_genre_form])

        assigns[:mads_genre_form].elementList.size.should == 1

        assigns[:mads_genre_form].scheme.size.should == 1
        assigns[:mads_genre_form].scheme.first.code.should == ['test']
        assigns[:mads_genre_form].scheme.first.name.should == ['Test Scheme 2']

      end
    end
  end

end
