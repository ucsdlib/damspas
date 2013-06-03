require 'spec_helper'
require 'net/http'
require 'json'

describe DamsObjectsController do
  describe "A login user" do
	  before do
	  	sign_in User.create!
	  end
	  describe "View" do
	    before do
	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013")
	      #puts @obj.id
	    end
	    it "should be successful" do 
	      get :view, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_object].should == @obj
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_object].should be_kind_of DamsObject
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013")
	    end
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      assigns[:dams_object].should == @obj
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do

#uri = URI('http://fast.oclc.org/fastSuggest/select')
#res = Net::HTTP.post_form(uri, 'q' => 'suggestall :cats', 'fl' => 'suggestall', 'wt' => 'json')
#puts "start"
#puts res.body
#json = JSON.parse(res.body)
#puts json
#jdoc = json.fetch("response").fetch("docs")
#puts jdoc

#jdoc.each do |value|
#	puts "heyy #{value['suggestall']}"
#end

	      expect { 
	       post :create, :dams_object => {titleValue: ["Test Title"], "subjectType"=>["Topic","BuiltWorkPlace","Temporal"], "subjectTypeValue"=>["testTopicValue","testWorkplaceValue1","testTemporal"]}	      
	       # post :create, :dams_object => {titleValue: ["Test Title"], beginDate: ["2013"], typeOfResource: ["text"], subjectValue: ["subjectValue1", "subjectValue2"]}
        }.to change { DamsObject.count }.by(1)
	      response.should redirect_to assigns[:dams_object]
	      assigns[:dams_object].should be_kind_of DamsObject
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013")
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :dams_object => {titleValue: ["Test Title2"], beginDate: ["2013"]}
	      response.should redirect_to assigns[:dams_object]
	      @obj.reload.titleValue.should == ["Test Title2"]
	      flash[:notice].should == "Successfully updated object"
	    end
    end
  end
end
