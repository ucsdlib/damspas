# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsPreferredCitationNote do
  subject do
    DamsPreferredCitationNote.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.value = "Data at Redshift=1.4 (RD0022)"
    subject.type = "citation"
    subject.displayLabel =  "Citation"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:PreferredCitationNote rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <dams:type>citation</dams:type>
    <dams:displayLabel>Citation</dams:displayLabel>
    <rdf:value>Data at Redshift=1.4 (RD0022)</rdf:value>
  </dams:PreferredCitationNote>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
