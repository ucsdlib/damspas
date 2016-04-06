# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsFamilyNameDatastream do
  describe "nested attributes" do
    it "should create rdf/xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/names/n90694888"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd0683587d"
      params = {
        familyName: {
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
      subject = MadsFamilyNameDatastream.new(double("inner object", pid:"bd93182924", new_record?: true))
      subject.attributes = params[:familyName]

      xml =<<END
<rdf:RDF xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <mads:FamilyName rdf:about="http://library.ucsd.edu/ark:/20775/bd93182924">
    <mads:authoritativeLabel>Burns, Jack O., Dr., 1977-</mads:authoritativeLabel>
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
  </mads:FamilyName>
</rdf:RDF>
END
      expect(subject.content).to be_equivalent_to xml
    end

    describe "a new instance" do
      subject { MadsFamilyNameDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXXXXX23")
      end

      it "should have a name" do
        subject.name = "Maria"
        expect(subject.name).to eq(["Maria"])
      end   
 
      it "element should update name" do
        subject.fullNameElement_attributes = {'0' => { elementValue: "Test" }}
        expect(subject.authLabel).to eq("Test")
      end
      it "element should not update name if name is already set" do
        subject.name = "Original"
        subject.fullNameElement_attributes = {'0' => { elementValue: "Test" }}
        expect(subject.name).to eq(["Original"])
        expect(subject.authLabel).to eq("Original")
      end
      it "element should not update name if element is blank" do
        subject.name = "Original"
        subject.fullNameElement_attributes = [{ elementValue: nil }]
        expect(subject.authLabel).to eq("Original")
      end
    end

    describe "an instance with content" do
      subject do
        subject = MadsFamilyNameDatastream.new(double('inner object', :pid=>'bd1775562z', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsFamilyName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        expect(subject.name).to eq(["Calder (Family : 1757-1959 : N.C.)"])
      end
 
      it "should have an scheme" do
        expect(subject.scheme.first.pid).to eq("bd0683587d")
      end
           
      it "should have fields" do
        list = subject.elementList
        expect("#{list[0].class.name}").to eq("Dams::MadsNameElements::MadsFamilyNameElement")
        expect(list[0].elementValue).to eq("Calder (Family :")  
        expect("#{list[1].class.name}").to eq("Dams::MadsNameElements::MadsDateNameElement")
        expect(list[1].elementValue).to eq("1757-1959 :")
        expect("#{list[2].class.name}").to eq("Dams::MadsNameElements::MadsTermsOfAddressNameElement")
        expect(list[2].elementValue).to eq("N.C.)")                           
        expect(list.size).to eq(3)  
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["family_name_element_tesim"]).to eq(["Calder (Family :"])
        expect(solr_doc["date_name_element_tesim"]).to eq(["1757-1959 :"])
        expect(solr_doc["terms_of_address_name_element_tesim"]).to eq(["N.C.)"])     
      end    
    end
  end
end
