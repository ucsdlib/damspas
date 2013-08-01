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
        post :create, mads_topic: {}
        flash[:notice].should == "Topic has been saved"
        response.should redirect_to mads_topic_path(assigns[:mads_topic])

      end
    end
  end

end
