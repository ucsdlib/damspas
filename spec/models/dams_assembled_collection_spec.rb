require 'spec_helper'

describe DamsAssembledCollection do
  subject do
    DamsAssembledCollection.new pid: "bb03030303"
  end

  it "should create valid xml" do
    subject.title.build.value = "UCSD Electronic Theses and Dissertations"
    subject.title.first.type = "main"
    subject.date.build.beginDate = "2009-05-03"
    subject.scopeContentNote.build.value = "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    subject.scopeContentNote.first.displayLabel = "Scope and contents"
    subject.scopeContentNote.first.type = "scope_and_content"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
<dams:AssembledCollection rdf:about="http://library.ucsd.edu/ark:/20775/bb03030303">
    <dams:title>
      <dams:Title>
        <dams:type>main</dams:type>
        <rdf:value>UCSD Electronic Theses and Dissertations</rdf:value>
      </dams:Title>
    </dams:title>
    <dams:date>
      <dams:Date>
        <dams:beginDate>2009-05-03</dams:beginDate>
      </dams:Date>
    </dams:date>
    <dams:scopeContentNote>
      <dams:ScopeContentNote>
        <rdf:value>Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.</rdf:value>
        <dams:displayLabel>Scope and contents</dams:displayLabel>
        <dams:type>scope_and_content</dams:type>
      </dams:ScopeContentNote>
    </dams:scopeContentNote>
  </dams:AssembledCollection>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
