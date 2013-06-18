# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsScheme do
  subject do
    MadsScheme.new pid: "bd9386739x"
  end
  it "should create a xml" do
    subject.code = "lcsh"
    subject.name = "Library of Congress Subject Headings"
    xml =<<END
<rdf:RDF xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
    <rdfs:label>Library of Congress Subject Headings</rdfs:label>
    <mads:code>lcsh</mads:code>
  </mads:MADSScheme>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
