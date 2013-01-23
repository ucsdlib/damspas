require 'spec_helper'

describe DamsObj do
  
  before  do
    @damsObj = DamsObj.new
  end
  
  it "should have the specified datastreams" do
    @damsObj.datastreams.keys.should include("damsMetadata")
    @damsObj.damsMetadata.should be_kind_of DamsRdfDatastream
 end
  
  it "should create/update a title" do
    @damsObj.title = "Dams Object Title 1"
    @damsObj.title.should == ["Dams Object Title 1"]
  
    @damsObj.title = "Dams Object Title 2"
    @damsObj.title.should == ["Dams Object Title 2"]  
  end

  it "should create/update a subject" do
    @damsObj.subject = ["subject 1","subject 2"]
    @damsObj.subject.should == ["subject 1","subject 2"]

    @damsObj.subject = ["subject 3","subject 4"]
    @damsObj.subject.should == ["subject 3","subject 4"]
  end

  describe "Store to a repository" do
    before do
      DamsPerson.create! pid: "damsid:bbXXXXXXX1", name: "Maria"
    end
    it "should store/retrieve from a repository" do
      @damsObj.damsMetadata.content = File.new('spec/fixtures/dissertation.rdf.xml').read
      @damsObj.save!
      @damsObj.reload
      @damsObj.title.should == ["Chicano and black radical activism of the 1960s"]
    end
  end
end

