require 'spec_helper'

describe DamsEventDatastream do

  describe "event model" do

    describe "instance populated in-memory" do

      subject { DamsEventDatastream.new(double('inner object', :pid=>'xxXXXXXX24', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}xxXXXXXX24")
      end

      it "should have a type" do
        subject.type = "collection creation"
        expect(subject.type).to eq(["collection creation"])
      end

      it "should have an eventDate" do
        subject.eventDate = "2012-11-06T09:26:34-0500"
        expect(subject.eventDate).to eq(["2012-11-06T09:26:34-0500"])
      end

      it "should have an outcome" do
        subject.outcome = "success"
        expect(subject.outcome).to eq(["success"])
      end
      
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsEventDatastream.new(double('inner object', :pid=>'xx28282828', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsEvent.rdf.xml').read
        subject
      end
      before(:all) do
        @name = MadsPersonalName.create pid: 'xx08080808', name: 'Artist, Alice, 1966-'
        @role = MadsAuthority.create pid: 'xx55639754', name: 'Creator', code: 'cre'
      end
      after(:all) do
        @name.delete
        @role.delete
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}xx28282828")
      end

      it "should have a type" do
        expect(subject.type).to eq(["record created"])
      end

      it "should have an eventDate" do
        expect(subject.eventDate).to eq(["2012-11-06T09:26:34-0500"])
      end

      it "should have an outcome" do
        expect(subject.outcome).to eq(["success"])
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        expect(solr_doc["type_tesim"]).to eq(["record created"])
        expect(solr_doc["eventDate_tesim"]).to eq(["2012-11-06T09:26:34-0500"])
        expect(solr_doc["outcome_tesim"]).to eq(["success"])
      end   
      
      it "should have relationship" do
        expect(subject.relationship.first.personalName.first.pid).to eq("xx08080808")
        expect(subject.relationship.first.role.first.pid).to eq("xx55639754")
        solr_doc = subject.to_solr
        expect(solr_doc["name_tesim"]).to eq(["Artist, Alice, 1966-"])
        expect(solr_doc["role_tesim"]).to eq(["Creator"])
        expect(solr_doc["role_code_tesim"]).to eq(["cre"])
      end
    end
  end
end
