# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsTechnique do
  subject do
    DamsTechnique.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Impasto"
    subject.authority = "XXX"
    subject.valueURI =  "http://id.loc.gov/XXX04"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Technique rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>Impasto</mads:authoritativeLabel>
    <dams:authority>XXX</dams:authority>
    <dams:valueURI rdf:resource="http://id.loc.gov/XXX04"/>
  </dams:Technique>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
