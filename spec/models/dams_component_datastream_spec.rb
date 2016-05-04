require 'spec_helper'

describe DamsComponentDatastream do

  describe "a component model" do

    describe "instance populated in-memory" do

      subject { DamsComponentDatastream.new(double('inner object', :pid=>'zz12345678', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}zz12345678")
      end
      it "should have a title" do
        subject.titleValue = "The Static Image"
        expect(subject.titleValue).to eq("The Static Image")
      end
      it "should have a date" do
        subject.dateValue = "2012-06-24"
        expect(subject.dateValue).to eq(["2012-06-24"])
      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsComponentDatastream.new(double('inner object', :pid=>'zz12345678', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsComponent.rdf.xml').read
        subject
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}zz12345678")
      end
      it "should have a title" do
        expect(subject.titleValue).to eq("The Static Image")
      end
      it "should have a date" do
        expect(subject.beginDate).to eq(["2012-06-24"])
      end

 	  it "should index title and dates" do
        solr_doc = subject.to_solr
        expect(solr_doc["title_tesim"]).to include "The Static Image: Foo!"
        expect(solr_doc["date_tesim"]).to include "2012-06-24"
     	expect(solr_doc["date_tesim"]).to include "2012-06-25"
     	expect(solr_doc["date_tesim"]).to include "June 24-25, 2012"
      end

 	  it "should have notes" do
        solr_doc = subject.to_solr
        expect(solr_doc["note_tesim"]).to include "1 PDF (xi, 111 p.)"
      end                

    end
  end
end
