require 'spec_helper'

describe MadsSchemeDatastream do

  describe "a MADS Scheme model" do

    describe "instance populated in-memory" do

      subject { MadsSchemeDatastream.new(double('inner object', :pid=>'bd9386739x', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bd9386739x")
      end

      it "should have a name" do
        subject.name = "Test Scheme Name"
        expect(subject.name).to eq(["Test Scheme Name"])
      end

      it "should have a code" do
        subject.code = "Test Scheme Code"
        expect(subject.code).to eq(["Test Scheme Code"])
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = MadsSchemeDatastream.new(double('inner object', :pid=>'bd9386739x', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsScheme.rdf.xml').read
        subject
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bd9386739x")
      end

      it "should have a name" do
        expect(subject.name).to eq(["Library of Congress Subject Headings"])
      end

      it "should have a code" do
        expect(subject.code).to eq(["lcsh"])
      end

    end
  end
end
