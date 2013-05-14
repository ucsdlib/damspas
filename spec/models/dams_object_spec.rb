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
    subject.sourceCapture.scannerManufacturer.should == ["Epson"]
  end
  
  subject do
    DamsObject.new pid: "xx80808080"
  end
  it "should create a xml" do
    subject.titleValue = "Sample Complex Object Record #1"
    subject.subtitle = "a newspaper PDF with a single attached image"
    subject.titleType = "main"
    subject.dateValue = "May 24, 1980"
    subject.beginDate = "1980-05-24"
    subject.endDate = "1980-05-24"
    subject.subjectValue = "Black Panther Party--History"
    subject.subjectURI = "bd6724414c"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    xmlns:damsid="http://library.ucsd.edu/ark:/20775/">
<dams:Object rdf:about="http://library.ucsd.edu/ark:/20775/xx80808080">
    <dams:title>
      <dams:Title>
        <rdf:value>Sample Complex Object Record #1</rdf:value>
        <dams:subtitle>a newspaper PDF with a single attached image</dams:subtitle>
        <dams:type>main</dams:type>
      </dams:Title>
    </dams:title>
	<dams:date>
      <dams:Date>
        <rdf:value>May 24, 1980</rdf:value>
        <dams:beginDate>1980-05-24</dams:beginDate>
        <dams:endDate>1980-05-24</dams:endDate>
      </dams:Date>
    </dams:date>    
    <dams:subject>
      <mads:ComplexSubject>
        <mads:authoritativeLabel>Black Panther Party--History</mads:authoritativeLabel>
      </mads:ComplexSubject>
    </dams:subject>   
    <dams:subject rdf:resource="http://library.ucsd.edu/ark:/20775/bd6724414c"/> 
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end  
end
