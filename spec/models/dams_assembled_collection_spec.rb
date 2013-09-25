require 'spec_helper'

describe DamsAssembledCollection do
  subject do
    DamsAssembledCollection.new pid: "bb03030303"
  end

  it "should create valid xml" do
    subject.titleValue = "UCSD Electronic Theses and Dissertations"
    subject.beginDate = "2009-05-03"
    subject.visibility = "public"
    subject.resource_type = "text"
    subject.scopeContentNote.build.value = "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    subject.scopeContentNote.first.displayLabel = "Scope and contents"
    subject.scopeContentNote.first.type = "scope_and_content"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#"
         xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
<dams:AssembledCollection rdf:about="#{Rails.configuration.id_namespace}bb03030303">
  <dams:visibility>public</dams:visibility>
  <dams:typeOfResource>text</dams:typeOfResource>
    <dams:title>
<mads:Title>
  <mads:authoritativeLabel>UCSD Electronic Theses and Dissertations</mads:authoritativeLabel>
  <mads:elementList rdf:parseType="Collection">
    <mads:MainTitleElement>
      <mads:elementValue>UCSD Electronic Theses and Dissertations</mads:elementValue>
    </mads:MainTitleElement>
  </mads:elementList>
</mads:Title>
    </dams:title>
    <dams:date>
      <dams:Date>
        <dams:beginDate>2009-05-03</dams:beginDate>
      </dams:Date>
    </dams:date>
    <dams:scopeContentNote>
      <dams:ScopeContentNote>
        <dams:displayLabel>Scope and contents</dams:displayLabel>
        <dams:type>scope_and_content</dams:type>
        <rdf:value>Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.</rdf:value>        
      </dams:ScopeContentNote>
    </dams:scopeContentNote>
  </dams:AssembledCollection>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
