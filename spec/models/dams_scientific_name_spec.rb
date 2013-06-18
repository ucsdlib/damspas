# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsScientificName do
  subject do
    DamsScientificName.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Western lowland gorilla (Gorilla gorilla gorilla)"
    subject.scheme = "bd6792855f"
    subject.externalAuthority =  "http://dbpedia.org/page/Western_lowland_gorilla"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
<dams:ScientificName rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:hasExactExternalAuthority rdf:resource="http://dbpedia.org/page/Western_lowland_gorilla"/>
    <mads:authoritativeLabel>Western lowland gorilla (Gorilla gorilla gorilla)</mads:authoritativeLabel>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd6792855f"/>
  </dams:ScientificName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
