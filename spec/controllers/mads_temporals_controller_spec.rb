require 'spec_helper'

describe MadsTemporalsController do
  before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:mads_temporal].should be_kind_of MadsTemporal
        assigns[:mads_temporal].elementList.first.temporalElement.size.should == 1
      end
    end

    describe "#create" do
      it "should set the attributes" do
        post :create, mads_temporal: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "elementList_attributes"=>{"0"=>{"temporalElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/xx00000139"}]}
        flash[:notice].should == "Temporal has been saved"
        response.should redirect_to mads_temporal_path(assigns[:mads_temporal])

        #puts assigns[:mads_temporal].damsMetadata.serialize
        assigns[:mads_temporal].elementList.size.should == 1

        assigns[:mads_temporal].scheme.first.code.should == ['test']
        assigns[:mads_temporal].scheme.first.name.should == ['Test Scheme']

      end
      it "should require a name" do  		
	  	  temporalObject = MadsTemporal.create(name: "", externalAuthority: "http://test.com")
	  	  temporalObject.valid?
	      temporalObject.errors.should have_key(:label)
	      temporalObject.errors.full_messages.should include 'Label can\'t be blank'
	   end        
    end
  end
end
