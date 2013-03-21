require 'spec_helper'

describe DamsObject do
  
  before  do
    @damsObj = DamsObject.new(pid: 'bb52572546')
  end
  
  it "should have the specified datastreams" do
    @damsObj.datastreams.keys.should include("damsMetadata")
    @damsObj.damsMetadata.should be_kind_of DamsObjectDatastream
  end
  
  it "should create/update a title" do
    @damsObj.titleValue.should == []
    @damsObj.titleValue = "Dams Object Title 1"
    @damsObj.titleValue.should == ["Dams Object Title 1"]
  
    @damsObj.titleValue = "Dams Object Title 2"
    @damsObj.titleValue.should == ["Dams Object Title 2"]  
  end

  it "should create/update a subject" do
    pending "should be able to create topic, temporal, stylePeriod, ..."
    #@damsObj.subject.first.authoritativeLabel = "subject 1"
    #@damsObj.subject.second.authoritativeLabel = "subject 2"
    #@damsObj.subject.first.authoritativeLabel.should == ["subject 1"]
    #@damsObj.subject.second.authoritativeLabel.should == ["subject 2"]

    #@damsObj.subject.first.authoritativeLabel = "subject 3"
    #@damsObj.subject.second.authoritativeLabel = "subject 4"
    #@damsObj.subject.first.authoritativeLabel.should == ["subject 3"]
    #@damsObj.subject.second.authoritativeLabel.should == ["subject 4"]
  end

  describe "Store to a repository" do
    before do
      MadsPersonalName.create! pid: "zzXXXXXXX1", name: "Maria", sameAs: "someUrl"
    end
    after do
      #@damsObj.delete
    end
    it "should store/retrieve from a repository" do
      @damsObj.damsMetadata.content = File.new('spec/fixtures/dissertation.rdf.xml').read
      #@damsObj.titleValue.should == ["Chicano and black radical activism of the 1960s"]
      @damsObj.save!
      #puts "PID #{@damsObj.pid}"
      @damsObj.reload
      loadedObj = DamsObject.find(@damsObj.pid)
      #puts "CONTENT #{loadedObj.damsMetadata.content}"
      loadedObj.titleValue.should == ["Chicano and black radical activism of the 1960s"]
    end
  end

  subject do
    DamsObject.new pid: 'bb80808080'
  end
  it "should load a complex object from RDF/XML file" do
    subject = DamsObject.new(:pid=>'bb80808080')

    subject.damsMetadata.content = File.new('spec/fixtures/damsComplexObject1.rdf.xml').read
    subject.titleValue.should == ["Sample Complex Object Record #1"]
    subject.component.first.title.first.value.should == ["The Static Image"]
    subject.source_capture.scannerManufacturer.should == ["Epson"]
  end
end
