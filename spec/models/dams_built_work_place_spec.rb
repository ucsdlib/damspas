# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsBuiltWorkPlace do
  subject do
    DamsBuiltWorkPlace.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "The Getty Center"
    subject.authority = "CONA"
    subject.valueURI =  "http://www.getty.edu/cona/CONAFullSubject.aspx?subid=700001994"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
<dams:BuiltWorkPlace rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>The Getty Center</mads:authoritativeLabel>
    <dams:authority>CONA</dams:authority>
    <dams:valueURI rdf:resource="http://www.getty.edu/cona/CONAFullSubject.aspx?subid=700001994"/>
    
  </dams:BuiltWorkPlace>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
