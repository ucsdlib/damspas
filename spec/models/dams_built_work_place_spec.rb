# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsBuiltWorkPlace do
  subject do
    DamsBuiltWorkPlace.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "The Getty Center"
    subject.scheme = "bd2936165m"
    subject.externalAuthority =  "http://www.getty.edu/cona/CONAFullSubject.aspx?subid=700001994"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
<dams:BuiltWorkPlace rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>The Getty Center</mads:authoritativeLabel>
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd2936165m"/>
    <mads:hasExactExternalAuthority rdf:resource="http://www.getty.edu/cona/CONAFullSubject.aspx?subid=700001994"/>
  </dams:BuiltWorkPlace>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
