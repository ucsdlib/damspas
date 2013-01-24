require 'spec_helper'

describe DamsObjectsController do
  describe "Show" do
    before do
      @obj = DamsObject.create(title: "Test Title", date: "2013")
    end
    it "should be successful" do 
      get :show, id: @obj.id
      response.should be_successful 
      assigns[:dams_object].should == @obj
    end
  end
end
