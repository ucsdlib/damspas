# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsCorporateNameDatastream do
  describe "nested attributes" do
    it "should create rdf/xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/names/n90694888"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd0683587d"
      params = {
        corporateName: {
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
      subject = MadsCorporateNameDatastream.new(double("inner object", pid:"bd93182924", new?: true))
      subject.attributes = params[:corporateName]

      xml =<<END
<rdf:RDF xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <mads:CorporateName rdf:about="http://library.ucsd.edu/ark:/20775/bd93182924">
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
  </mads:CorporateName>
</rdf:RDF>
END
      subject.content.should be_equivalent_to xml
    end

    describe "a new instance" do
      subject { MadsCorporateNameDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
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
        subject = MadsCorporateNameDatastream.new(double('inner object', :pid=>'bd8021352s', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsCorporateName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Burns, Jack O., Dr., 1977-, Lawrence Livermore Laboratory"]
      end
 
      it "should have an scheme" do
        subject.scheme.first.pid.should == "bd0683587d"
      end
           
      it "should have fields" do
        list = subject.elementList
        "#{list[0].class.name}".should == "Dams::MadsNameElements::MadsFullNameElement"
        list[0].elementValue.should == "Burns, Jack O."  
        "#{list[1].class.name}".should == "Dams::MadsNameElements::MadsFamilyNameElement"
        list[1].elementValue.should == "Burns"   
        "#{list[2].class.name}".should == "Dams::MadsNameElements::MadsGivenNameElement"
        list[2].elementValue.should == "Jack O."  
        "#{list[3].class.name}".should == "Dams::MadsNameElements::MadsDateNameElement"
        list[3].elementValue.should == "1977-"
        "#{list[4].class.name}".should == "Dams::MadsNameElements::MadsTermsOfAddressNameElement"
        list[4].elementValue.should == "Dr."
        "#{list[5].class.name}".should == "Dams::MadsNameElements::MadsNameElement"
        list[5].elementValue.should == "Lawrence Livermore Laboratory"                                 
        list.size.should == 6        
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["corporate_name_tesim"].should == ["Burns, Jack O., Dr., 1977-, Lawrence Livermore Laboratory"]
        solr_doc["full_name_element_tesim"].should == ["Burns, Jack O."]
        solr_doc["family_name_element_tesim"].should == ["Burns"] 
        solr_doc["given_name_element_tesim"].should == ["Jack O."]
        solr_doc["date_name_element_tesim"].should == ["1977-"]
        solr_doc["name_element_tesim"].should == ["Lawrence Livermore Laboratory"]          
      end    
    end
  end
end
