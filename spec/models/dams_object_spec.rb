require 'spec_helper'

describe DamsObject do
  
  before  do
    DamsObject.find_each {|z| z.delete}
    @damsObj = DamsObject.new
  end
  
  it "should have the specified datastreams" do
    @damsObj.datastreams.keys.should include("damsMetadata")
    @damsObj.damsMetadata.should be_kind_of DamsObjectDatastream
    @damsObj.datastreams.keys.should include("rightsMetadata")
    @damsObj.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
 end
  
  it "should have a title" do
    @damsObj.title = "Dams Object Title 1"
    @damsObj.title == "Dams Object Title 1"
  end
  
  it "should have ark Url" do
    @damsObj.arkUrl = "bb1234567"
    @damsObj.arkUrl == "bb1234567"
  end

  it "should have a related title" do
    @damsObj.relatedTitle = "Dams Object Related Title 1"
    @damsObj.relatedTitle == "Dams Object Related Title 1"
  end

  it "should have a related title type" do
    @damsObj.relatedTitleType = "translated"
    @damsObj.relatedTitleType == "translated"
  end

  it "should have a relatedTitleLang" do
    @damsObj.relatedTitleLang = "fr"
    @damsObj.relatedTitleLang == "fr"
  end

  it "should have a beginDate" do
    @damsObj.beginDate = "2012-11-27"
    @damsObj.beginDate == "2012-11-27"
  end

  it "should have an endDate" do
    @damsObj.endDate = "2012-11-30"
    @damsObj.endDate == "2012-11-30"
  end

  it "should have a date" do
    @damsObj.date = "2012-11-29"
    @damsObj.date == "2012-11-29"
  end



end

