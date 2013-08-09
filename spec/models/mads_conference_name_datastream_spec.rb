# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsConferenceNameDatastream do
  describe "nested attributes" do
    it "should create rdf/xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/names/n90694888"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd0683587d"
      params = {
        conferenceName: {
          name: "Burns, Jack O., Dr., 1977-", externalAuthority: exturi,         
          familyNameElement_attributes: [{ elementValue: "Burns" }],
          givenNameElement_attributes: [{ elementValue: "Jack O." }],
          termsOfAddressNameElement_attributes: [{ elementValue: "Dr." }],
          dateNameElement_attributes: [{ elementValue: "1977-" }],
          fullNameElement_attributes: [{ elementValue: "FullNameValue" }],
          nameElement_attributes: [{ elementValue: "NameElementValue" }],
          scheme_attributes: [
            id: scheme, code: "naf", name: "Library of Congress Name Authority File"
          ]
        }
      }
      subject = MadsConferenceNameDatastream.new(double("inner object", pid:"bd93182924", new?: true))
      subject.attributes = params[:conferenceName]

      xml =<<END
<rdf:RDF xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <mads:ConferenceName rdf:about="http://library.ucsd.edu/ark:/20775/bd93182924">
    <mads:authoritativeLabel>FullNameValue, Burns, Jack O., Dr., NameElementValue, 1977-</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">  
      <mads:FamilyNameElement>
        <mads:elementValue>Burns</mads:elementValue>
      </mads:FamilyNameElement>
      <mads:GivenNameElement>
        <mads:elementValue>Jack O.</mads:elementValue>
      </mads:GivenNameElement>
      <mads:TermsOfAddressNameElement>
         <mads:elementValue>Dr.</mads:elementValue>
      </mads:TermsOfAddressNameElement>
      <mads:DateNameElement>
        <mads:elementValue>1977-</mads:elementValue>
      </mads:DateNameElement>
      <mads:FullNameElement>
        <mads:elementValue>FullNameValue</mads:elementValue>
      </mads:FullNameElement>
      <mads:NameElement>
        <mads:elementValue>NameElementValue</mads:elementValue>
      </mads:NameElement>            
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/names/n90694888"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="http://library.ucsd.edu/ark:/20775/bd0683587d">
        <mads:code>naf</mads:code>
        <rdfs:label>Library of Congress Name Authority File</rdfs:label>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
  </mads:ConferenceName>
</rdf:RDF>
END
      subject.content.should be_equivalent_to xml
    end

    describe "a new instance" do
      subject { MadsConferenceNameDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Maria"
        subject.name.should == ["Maria"]
      end   
 
      it "should set the name when the elementList is set" do
        subject.name = "Original"
        subject.fullNameElement_attributes = {'0' => { elementValue: "Test" }}
        subject.name.should == ["Test"]
      end
      it "should set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.fullNameElement_attributes = [{ elementValue: nil }]
        subject.name.should == ["Original"]       
      end
    end

    describe "an instance with content" do
      subject do
        subject = MadsConferenceNameDatastream.new(double('inner object', :pid=>'bd0478622c', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsConferenceName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["American Library Association. Annual Conference"]
      end
 
      it "should have an scheme" do
        subject.scheme.first.pid.should == "bd0683587d"
      end
           
      it "should have fields" do
        list = subject.elementList
        "#{list[0].class.name}".should == "Dams::MadsNameElements::MadsNameElement"
        list[0].elementValue.should == "American Library Association."  
        "#{list[1].class.name}".should == "Dams::MadsNameElements::MadsNameElement"
        list[1].elementValue.should == "Annual Conference"                            
        list.size.should == 2        
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["conference_name_tesim"].should == ["American Library Association. Annual Conference"]
        solr_doc["name_element_tesim"].should == ["American Library Association."]          
      end    
    end
  end
end