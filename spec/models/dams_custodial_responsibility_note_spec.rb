# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCustodialResponsibilityNote do
  subject do
    DamsCustodialResponsibilityNote.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.value = "Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://library.ucsd.edu/locations/mscl/)"
    subject.type = "custodial_history"
    subject.displayLabel =  "Digital object made available by"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:CustodialResponsibilityNote rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <dams:type>custodial_history</dams:type>
    <dams:displayLabel>Digital object made available by</dams:displayLabel>
    <rdf:value>Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://library.ucsd.edu/locations/mscl/)</rdf:value>
  </dams:CustodialResponsibilityNote>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
