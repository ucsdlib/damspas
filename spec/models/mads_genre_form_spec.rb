# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsGenreForm do
  let(:params) {
    {name: "Film and video adaptions", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        genreFormElement_attributes: [{ elementValue: "Film and video adaptions" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    MadsGenreForm.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create a xml" do
    xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:GenreForm rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Film and video adaptions</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <mads:GenreFormElement>
        <mads:elementValue>Film and video adaptions</mads:elementValue>
      </mads:GenreFormElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
  </mads:GenreForm>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
  
  it "should have genreFormElement" do
    subject.genreFormElement.first.elementValue.should == 'Film and video adaptions'
  end

  it "should be able to build a new genreFormElement" do
    subject.elementList.genreFormElement.build
  end  
end
