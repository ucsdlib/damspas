# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsPersonalName do
  subject do
    DamsPersonalName.new pid: "bbXXXXXXX1"
  end
  it "should create a xml" do
    subject.name = "Maria"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
  <mads:PersonalName rdf:about="http://library.ucsd.edu/ark:/20775/bbXXXXXXX1">
    <mads:authoritativeLabel>Maria</mads:authoritativeLabel>
  </mads:PersonalName>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
