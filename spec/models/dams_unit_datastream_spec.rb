require 'spec_helper'

describe DamsUnitDatastream do

  describe "a unit model" do

    describe "instance populated in-memory" do

      subject { DamsUnitDatastream.new(double('inner object', :pid=>'bbXXXXXX24', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bbXXXXXX24")
      end

      it "should have a name" do
        subject.name = "Test Unit"
        expect(subject.name).to eq(["Test Unit"])
      end

      it "should have a description" do
        subject.description = "Test Unit Description"
        expect(subject.description).to eq(["Test Unit Description"])
      end

      it "should have a code" do
        subject.code = "xyz"
        expect(subject.code).to eq(["xyz"])
      end

      it "should have a uri" do
        subject.uri = "http://library.ucsd.edu/units/test/"
        expect(subject.uri).to eq(["http://library.ucsd.edu/units/test/"])
      end

    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsUnitDatastream.new(double('inner object', :pid=>'bb45454545', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsUnit.rdf.xml').read
        subject
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bb45454545")
      end

      it "should have a name" do
        expect(subject.name).to eq(["Research Data Curation Program"])
      end

      it "should have a description" do
        expect(subject.description).to eq(["Research Cyberinfrastructure: the hardware, software, and people that support scientific research."])
      end

      it "should have a code" do
        expect(subject.code).to eq(["rdcp"])
      end

      it "should have a uri" do
        expect(subject.uri).to eq(["http://rci.ucsd.edu/"])
      end

    end
  end
end
