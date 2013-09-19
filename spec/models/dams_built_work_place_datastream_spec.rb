# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsBuiltWorkPlaceDatastream do
  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
      params = {
        builtWorkPlace: {
          name: "The Getty Center", externalAuthority: exturi,
          builtWorkPlaceElement_attributes: [{ elementValue: "The Getty Center" }],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = DamsBuiltWorkPlaceDatastream.new(double("inner object", pid:"zzXXXXXXX1", new?: true))
      subject.attributes = params[:builtWorkPlace]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dams="http://library.ucsd.edu/ontology/dams#">
 <dams:BuiltWorkPlace rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>The Getty Center</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">
      <dams:BuiltWorkPlaceElement>
        <mads:elementValue>The Getty Center</mads:elementValue>
      </dams:BuiltWorkPlaceElement>
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>    
  </dams:BuiltWorkPlace>
</rdf:RDF>
END
      subject.content.should be_equivalent_to xml
    end
    describe "a new instance" do
      subject { DamsBuiltWorkPlaceDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Baseball"
        subject.name.should == ["Baseball"]
      end

      it "should set the name (authoritativeLabel) when the elementList is set" do
        subject.name = "Original"
        subject.builtWorkPlaceElement_attributes = {'0' => { elementValue: "Test" }}
        subject.name.should == ["Test"]
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.builtWorkPlaceElement_attributes = [{ elementValue: nil }]
        subject.name.should == ["Original"]
      end
    end

    describe "an instance with content" do
      subject do
        subject = DamsBuiltWorkPlaceDatastream.new(double('inner object', :pid=>'bd1707307x', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsBuiltWorkPlace.rdf.xml').read
        subject
      end

      it "should have name" do
        subject.name.should == ["The Getty Center"]
      end

      it "should have an scheme" do
        subject.scheme.first.pid.should == "bd2936165m"
      end

      it "should have fields" do
        list = subject.elementList
        list[0].should be_kind_of Dams::DamsBuiltWorkPlace::DamsBuiltWorkPlaceElement
        list[0].elementValue.should == "The Getty Center"
        list.size.should == 1
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["built_work_place_tesim"].should == ["The Getty Center"]
        solr_doc["built_work_place_element_tesim"].should == ["The Getty Center"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd2936165m"]
        solr_doc["scheme_name_tesim"].should == ["Built Work Place"]
      end
    end

  end
end
