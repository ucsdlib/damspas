require 'spec_helper'

describe DamsRole do
  
  before  do
    DamsRole.find_each {|z| z.delete}
    @damsRole = DamsRole.new
  end
  
  it "should have the specified datastreams" do
    @damsRole.datastreams.keys.should include("damsRole")
    @damsRole.damsRole.should be_kind_of DamsRoleDatastream
    @damsRole.datastreams.keys.should include("rightsMetadata")
    @damsRole.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
 end
  
  it "should have a role code" do
    @damsRole.code = "cr"
    @damsRole.code == "cr"
  end

  it "should have a role" do
    @damsRole.value = "Creator"
    @damsRole.value == "Creator"
  end

  it "should have a  valueURI" do
    @damsRole.valueURI = "http://id.loc.gov/vocabulary/relators/cre"
    @damsRole.valueURI == "http://id.loc.gov/vocabulary/relators/cre"
  end

  it "should have a vocabulary" do
    @damsRole.code = "http://library.ucsd.edu/ark:/20775/bb14141414"
    @damsRole.code == "http://library.ucsd.edu/ark:/20775/bb14141414"
  end

end

