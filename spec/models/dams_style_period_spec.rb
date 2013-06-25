# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsStylePeriod do
  subject do
    DamsStylePeriod.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Impressionism"
    subject.scheme = "bd5495914b"
    subject.externalAuthority =  "http://styleperiod.org/XXX05"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:StylePeriod rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Impressionism</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://styleperiod.org/XXX05"/>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd5495914b"/>
  </dams:StylePeriod>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
