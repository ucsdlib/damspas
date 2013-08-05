# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsLanguage do
  let(:params) {
    {name: "French", code: "fre", externalAuthority: RDF::Resource.new("http://id.loc.gov/authorities/subjects/sh85124118"),
        languageElement_attributes: [{ elementValue: "French" }],
        scheme_attributes: [
          id: "http://library.ucsd.edu/ark:/20775/bd9386739x", code: "lcsh", name: "Library of Congress Subject Headings"
        ]
  }}
  subject do
    MadsLanguage.new(pid: 'zzXXXXXXX1').tap do |t|
      t.attributes = params
    end
  end
  it "should create rdf/xml" do
    xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:Language rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>French</mads:authoritativeLabel>
    <mads:code>fre</mads:code>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
    <mads:elementList rdf:parseType="Collection">
      <mads:LanguageElement>
        <mads:elementValue>French</mads:elementValue>
      </mads:LanguageElement>
    </mads:elementList>
  </mads:Language>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end

  it "should have languageElement" do
    subject.languageElement.first.elementValue.should == 'French'
  end

  it "should be able to build a new languageElement" do
    subject.elementList.languageElement.build
  end
end