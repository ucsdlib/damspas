require 'spec_helper'

describe MadsTopicsController do
	before do
		sign_in User.create!
  end

  describe "when signed in" do
    describe "#new" do
      it "should set the values needed to draw the form" do
        get :new
        response.should be_success
        assigns[:mads_topic].should be_kind_of MadsTopic
        assigns[:mads_topic].elementList.first.topicElement.size.should == 1
      end
    end

    describe "#create" do
      it "should set the attributes" do
        # TODO: add scheme record to pre-loaded sample data
        post :create, mads_topic: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "elementList_attributes"=>{"0"=>{"topicElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/xx00000139"}]}
        flash[:notice].should == "Topic has been saved"
        response.should redirect_to mads_topic_path(assigns[:mads_topic])

        puts assigns[:mads_topic].damsMetadata.serialize
        assigns[:mads_topic].elementList.size.should == 1

        assigns[:mads_topic].scheme.first.code.should == ['test']
        assigns[:mads_topic].scheme.first.name.should == ['Test Scheme']

      end
    end
  end

end
