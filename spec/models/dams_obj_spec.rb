require 'spec_helper'

describe DamsObj do
  
  before  do
    @damsObj = DamsObj.new
  end
  
  it "should have the specified datastreams" do
    @damsObj.datastreams.keys.should include("damsMetadata")
    @damsObj.damsMetadata.should be_kind_of DamsRdfDatastream
 end
  
  it "should have a title" do
    @damsObj.title = "Dams Object Title 1"
    @damsObj.title.should == ["Dams Object Title 1"]
  end
end

