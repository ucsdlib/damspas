# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsDAMSEvent do
  subject do
    DamsDAMSEvent.new pid: "zzXXXXXXX1"
  end
  it "should create xml" do
    subject.type = "collection creation"
    subject.eventDate = "2012-11-06T09:26:34-0500"
    subject.outcome = "success"
    xml =<<END
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:DAMSEvent rdf:about="http://library.ucsd.edu/ark:/20775/zzXXXXXXX1">    
    <dams:eventDate>2012-11-06T09:26:34-0500</dams:eventDate>
    <dams:outcome>success</dams:outcome>
    <dams:type>collection creation</dams:type>
   </dams:DAMSEvent>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
