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
    @damsObj.title.should == []
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
      DamsPerson.create! pid: "bbXXXXXXX1", name: "Maria"
    end
    after do
      #@damsObj.delete
    end
    it "should store/retrieve from a repository" do
      @damsObj.damsMetadata.content = File.new('spec/fixtures/dissertation.rdf.xml').read
      #@damsObj.title.should == ["Chicano and black radical activism of the 1960s"]
      @damsObj.save!
      #puts "PID #{@damsObj.pid}"
      @damsObj.reload
      loadedObj = DamsObject.find(@damsObj.pid)
      #puts "CONTENT #{loadedObj.damsMetadata.content}"
      loadedObj.title.should == ["Chicano and black radical activism of the 1960s"]
    end
  end

  subject do
    DamsObject.new pid: 'bb80808080'
  end
  it "should load a complex object from RDF/XML file" do
    subject = DamsObject.new(:pid=>'bb80808080')

    subject.damsMetadata.content = File.new('spec/fixtures/damsComplexObject1.rdf.xml').read
    subject.title.should == ["Sample Complex Object Record #1"]
    subject.component.first.title.first.value.should == ["The Static Image"]
  end
end
