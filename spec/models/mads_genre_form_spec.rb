# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsGenreForm do
  subject do
    MadsGenreForm.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "Film and video adaptions"
    subject.scheme = "bd9386739x"
    subject.externalAuthority =  "http://id.loc.gov/authorities/sh2002012502"
    subject.elementValue = "Film and video adaptions"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <mads:GenreForm rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Film and video adaptions</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/sh2002012502"/>    
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd9386739x"/>
    <mads:elementList rdf:parseType="Collection">
      <mads:GenreFormElement>
        <mads:elementValue>Film and video adaptions</mads:elementValue>
      </mads:GenreFormElement>
    </mads:elementList>    
  </mads:GenreForm>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
