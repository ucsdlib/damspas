# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCartographic do
  subject do
    DamsCartographic.new pid: "bb20202020"
  end
  it "should create a xml" do
    subject.scale = "1:20000"
    subject.projection = "equirectangular"
    subject.referenceSystem = "WGS84"
    subject.point = "29.67459,-82.37873"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:Cartographics rdf:about="#{Rails.configuration.id_namespace}bb20202020">
    <dams:scale>1:20000</dams:scale>
    <dams:projection>equirectangular</dams:projection>
    <dams:referenceSystem>WGS84</dams:referenceSystem>
    <dams:point>29.67459,-82.37873</dams:point>
  </dams:Cartographics>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
