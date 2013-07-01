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
    @damsObj.title.build
    #@damsObj.titleValue.should == []
    @damsObj.titleValue = "Dams Object Title 1"
    @damsObj.titleValue.should == "Dams Object Title 1"
  
    @damsObj.titleValue = "Dams Object Title 2"
    @damsObj.titleValue.should == "Dams Object Title 2"
  end

  it "should create/update a subject" do
    @damsObj.topic.build
    @damsObj.topic.first.name = "topic 1"
    @damsObj.topic.first.name.should == ["topic 1"]
    @damsObj.topic << MadsTopic.new( :name => "topic 2" )
    pending "should be able to access second and subsequent topics..."
    @damsObj.topic[1].name.should == ["topic 2"]

    @damsObj.topic.first.name = "topic 3"
    @damsObj.topic.first.name.should == ["topic 3"]
    @damsObj.topic.second.name = "topic 4"
    @damsObj.topic.second.name.should == ["topic 4"]
  end

  describe "Store to a repository" do
    before do
      MadsPersonalName.create! pid: "zzXXXXXXX1", name: "Maria", externalAuthority: "someUrl"
    end
    after do
      #@damsObj.delete
    end
    it "should store/retrieve from a repository" do
      @damsObj.damsMetadata.content = File.new('spec/fixtures/dissertation.rdf.xml').read
      @damsObj.save!
      @damsObj.reload
      loadedObj = DamsObject.find(@damsObj.pid)
      loadedObj.titleValue.should == "Chicano and black radical activism of the 1960s"
    end
  end

  subject do
    DamsObject.new pid: 'bb80808080'
  end
  it "should load a complex object from RDF/XML file" do
    subject = DamsObject.new(:pid=>'bb80808080')

    subject.damsMetadata.content = File.new('spec/fixtures/damsComplexObject1.rdf.xml').read
    subject.titleValue.should == "Sample Complex Object Record #1"
    subject.component.first.title.first.value.should == "The Static Image"
    subject.sourceCapture.scannerManufacturer.should == ["Epson"]
  end
  
  subject do
    DamsObject.new pid: "xx80808080"
  end
  it "should create a xml" do
    subject.titleValue = "Sample Complex Object Record #1"
    subject.subtitle = "a newspaper PDF with a single attached image"
    subject.title.first.name = "Sample Complex Object Record #1: a newspaper PDF with a single attached image"
    subject.dateValue = "May 24, 1980"
    subject.beginDate = "1980-05-24"
    subject.endDate = "1980-05-24"
    subject.subjectValue = ["Black Panther Party--History"]
    subject.subjectURI = ["bd6724414c"]
    subject.topic.build.name = "test subject"
    subject.languageURI = ["xx00000170"]
    subject.assembledCollectionURI = ["bb03030303"]
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    xmlns:damsid="#{Rails.configuration.id_namespace}">
<dams:Object rdf:about="#{Rails.configuration.id_namespace}xx80808080">
    <dams:title>
      <mads:Title>
        <mads:authoritativeLabel>Sample Complex Object Record #1: a newspaper PDF with a single attached image</mads:authoritiatveLabel>
        <mads:elementList rdf:parseType="Collection">
          <mads:MainTitleElement>
            <mads:elementValue>Sample Complex Object Record #1</mads:elementValue>
          </mads:MainTitleElement>
          <mads:SubTitleElement>
            <mads:elementValue>a newspaper PDF with a single attached image</mads:elementValue>
          </mads:SubTitleElement>
        </mads:elementList>
      </mads:Title>
    </dams:title>
    <dams:topic>
        <mads:Topic>
            <mads:authoritativeLabel>test subject</ns2:authoritativeLabel>
        </mads:Topic>
    </dams:topic>
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
    <dams:subject rdf:resource="#{Rails.configuration.id_namespace}bd6724414c"/>
    <dams:language rdf:resource="#{Rails.configuration.id_namespace}xx00000170"/> 
    <dams:assembledCollection rdf:resource="#{Rails.configuration.id_namespace}bb03030303"/> 
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end  
end
