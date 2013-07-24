# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsLanguage do
  subject do
    MadsLanguage.new pid: "zzXXXXXXX1"
  end
  it "should create a xml" do    
    subject.name = "French"
    subject.code = "fre"
    subject.externalAuthority = "http://id.loc.gov/vocabulary/languages/fre"
    subject.elementValue = "French"
    subject.scheme = "bd71341600"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:Language rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>French</mads:authoritativeLabel>
    <mads:code>fre</mads:code>
    <mads:elementList rdf:parseType="Collection">
      <mads:LanguageElement>
        <mads:elementValue>French</mads:elementValue>
      </mads:LanguageElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/vocabulary/languages/fre"/> 
    <mads:isMemberOfMADSScheme rdf:resource="#{Rails.configuration.id_namespace}bd71341600"/>
  </mads:Language>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
