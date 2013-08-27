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
        assigns[:mads_topic].topicElement.size.should == 1
      end
    end

    describe "#create" do
      let!(:scheme) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      after { scheme.destroy }

      it "should set the attributes" do
        post :create, mads_topic: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "topicElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme.pid}"}]}
        flash[:notice].should == "Topic has been saved"
        response.should redirect_to mads_topic_path(assigns[:mads_topic])

        assigns[:mads_topic].elementList.size.should == 1

        assigns[:mads_topic].scheme.first.code.should == ['test']
        assigns[:mads_topic].scheme.first.name.should == ['Test Scheme']

      end
    end

    describe "#update" do
      let!(:scheme1) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:scheme2) { MadsScheme.create(code: 'test', name: 'Test Scheme')}
      let!(:topic) { MadsTopic.create(scheme_attributes: [{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme1.pid}"}])}
      after do
        topic.destroy 
        scheme1.destroy
        scheme2.destroy
      end

      it "should set the attributes" do
        put :update, id: topic, mads_topic: {"name"=>"TestLabel", "externalAuthority"=>"http://test.com", "topicElement_attributes"=>{"0"=>{"elementValue"=>"Baseball"}}, "scheme_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/#{scheme2.pid}"}]}
        flash[:notice].should == "Successfully updated Topic"
        response.should redirect_to mads_topic_path(assigns[:mads_topic])

        assigns[:mads_topic].elementList.size.should == 1

        assigns[:mads_topic].scheme.size.should == 1
        assigns[:mads_topic].scheme.first.code.should == ['test']
        assigns[:mads_topic].scheme.first.name.should == ['Test Scheme']

      end
    end
  end

end
