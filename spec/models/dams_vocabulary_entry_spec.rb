# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsVocabularyEntry do
  subject do
    DamsVocabularyEntry.new pid: "bb47474747"
  end
  it "should create xml" do
  	subject.vocabulary = "http://library.ucsd.edu/ark:/20775/bb43434343"
    subject.authority = "ISO 3166-1"
    subject.code = "us"
    subject.value = "United States"
    subject.valueURI = "http://www.loc.gov/standards/mods/"   
    subject.authorityURI = "http://www.loc.gov/standards/mods/"    
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#">
  <dams:VocabularyEntry rdf:about="http://library.ucsd.edu/ark:/20775/bb47474747">
    <dams:vocabulary rdf:resource="http://library.ucsd.edu/ark:/20775/bb43434343"/>
    <dams:authority>ISO 3166-1</dams:authority>
    <dams:code>us</dams:code>
    <rdf:value>United States</rdf:value>
    <dams:authorityURI>http://www.loc.gov/standards/mods/</dams:authorityURI>
    <dams:valueURI>http://www.loc.gov/standards/mods/</dams:valueURI>
  </dams:VocabularyEntry>
</rdf:RDF>
END

    subject.damsMetadata.content.should be_equivalent_to xml

  end
end
