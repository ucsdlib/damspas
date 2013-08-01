# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTopicDatastream do

  describe "nested attributes" do
    it "should create a xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
      params = {
        topic: {
          name: "Socialism", externalAuthority: exturi,
          elementList_attributes: [
            topicElement_attributes: [{ elementValue: "Socialism" }]
          ],
          scheme_attributes: [
            id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
          ]
        }
      }

      subject = MadsTopicDatastream.new(double("inner object", pid:"zzXXXXXXX1", new?: true))
      subject.attributes = params[:topic]

      xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:Topic rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Socialism</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
    <mads:elementList rdf:parseType="Collection">
      <mads:TopicElement>
        <mads:elementValue>Socialism</mads:elementValue>
      </mads:TopicElement>
    </mads:elementList>
  </mads:Topic>
</rdf:RDF>
END
      subject.content.should be_equivalent_to xml
    end
    describe "a new instance" do
      subject { MadsTopicDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Baseball"
        subject.name.should == ["Baseball"]
      end

      it "should set the name when the elementList is set" do
        subject.name = "Original"
        subject.elementList_attributes = [topicElement_attributes: {'0' => { elementValue: "Test" }}]
        subject.name.should == ["Test"]
      end
      it "shouldn't set the name when the elementList doesn't have an elementValue" do
        subject.name = "Original"
        subject.elementList_attributes = [topicElement_attributes: [{ elementValue: nil }]]
        subject.name.should == ["Original"]
      end
    end

    describe "an instance with content" do
      subject do
        subject = MadsTopicDatastream.new(double('inner object', :pid=>'bd46424836', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsTopic.rdf.xml').read
        subject
      end

      it "should have name" do
        subject.name.should == ["Baseball"]
      end

      it "should have an scheme" do
        subject.scheme.first.pid.should == "bd9386739x"
      end

      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of MadsTopicDatastream::MadsTopicElement
        list[0].elementValue.should == ["Baseball"]
        list.size.should == 1
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["topic_tesim"].should == ["Baseball"]
        solr_doc["topic_element_tesim"].should == ["Baseball"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd9386739x"]
        solr_doc["scheme_name_tesim"].should == ["Library of Congress Subject Headings"]
      end
    end

  end
end
