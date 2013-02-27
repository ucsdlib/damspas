# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsGenreForm do
  subject do
    MadsGenreForm.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Film and video adaptions"
    subject.authority = "lcsh"
    subject.sameAs =  "http://id.loc.gov/authorities/sh2002012502"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <mads:GenreForm rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">
    <mads:authoritativeLabel>Film and video adaptions</mads:authoritativeLabel>
    <dams:authority>lcsh</dams:authority>
    <owl:sameAs rdf:resource="http://id.loc.gov/authorities/sh2002012502"/>
  </mads:GenreForm>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
