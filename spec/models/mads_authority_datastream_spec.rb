require 'spec_helper'

describe MadsAuthorityDatastream do
  describe "a MADS Authority model" do

    describe "instance populated in-memory" do

      subject { MadsAuthorityDatastream.new(double('inner object', :pid=>'bd8396905c', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bd8396905c")
      end

      it "should have a name" do
        subject.name = "Test Authority Name"
        expect(subject.name).to eq(["Test Authority Name"])
      end

      it "should have a code" do
        subject.code = "Test Authority Code"
        expect(subject.code).to eq(["Test Authority Code"])
      end

      it "should have a description" do
        subject.code = "Test Authority Description"
        expect(subject.code).to eq(["Test Authority Description"])
      end

      #it "should have a scheme" do
      #  subject.scheme = "bd0683587d"
      #  subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd0683587d"
      #end
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = MadsAuthorityDatastream.new(double('inner object', :pid=>'bd8396905c', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsAuthority.rdf.xml').read
        subject
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bd8396905c")
      end

      it "should have a name" do
        expect(subject.name).to eq(["Repository"])
      end

      it "should have a code" do
        expect(subject.code).to eq(["rps"])
      end

      it "should have a description" do
        expect(subject.description).to eq(["An organization that hosts data or material culture objects and provides services to promote long term, consistent and shared use of those data or objects."])
      end

      it "should have a scheme" do
        expect(subject.scheme.first.pid).to eq("bd9386739x")
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["code_tesim"]).to eq(["rps"])
        expect(solr_doc["name_tesim"]).to eq(["Repository"])
        expect(solr_doc["scheme_tesim"]).to eq(["#{Rails.configuration.id_namespace}bd9386739x"])
        expect(solr_doc["scheme_name_tesim"]).to eq(["Library of Congress Subject Headings"])
        expect(solr_doc["scheme_code_tesim"]).to eq(["lcsh"])
        expect(solr_doc["externalAuthority_tesim"]).to eq(["http://id.loc.gov/vocabulary/relators/rps"])
      end    
    end
  end
end
