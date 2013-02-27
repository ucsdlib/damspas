# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsScopeContentNote do
  subject do
    DamsScopeContentNote.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.value = "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    subject.type = "scope_and_content"
    subject.displayLabel =  "Scope and contents"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
	<dams:ScopeContentNote rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
       <rdf:value>Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.</rdf:value>
        <dams:displayLabel>Scope and contents</dams:displayLabel>
        <dams:type>scope_and_content</dams:type>
    </dams:ScopeContentNote>  
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
