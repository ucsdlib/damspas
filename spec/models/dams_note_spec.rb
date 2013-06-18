# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsNote do
  subject do
    DamsNote.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.value = "#{Rails.configuration.id_namespace}bb80808080"
    subject.type = "identifier"
    subject.displayLabel =  "ARK ID"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Note rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <dams:displayLabel>ARK ID</dams:displayLabel>
    <dams:type>identifier</dams:type>    
    <rdf:value>#{Rails.configuration.id_namespace}bb80808080</rdf:value>
 </dams:Note>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
