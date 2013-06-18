# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsIconography do
  subject do
    DamsIconography.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Madonna and Child"
    subject.scheme = "bd1980525k"
    subject.externalAuthority =  "http://iconography.org/XXX03"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Iconography rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">  
    <mads:hasExactExternalAuthority rdf:resource="http://iconography.org/XXX03"/>
    <mads:authoritativeLabel>Madonna and Child</mads:authoritativeLabel>    
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd1980525k"/>
  </dams:Iconography>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
