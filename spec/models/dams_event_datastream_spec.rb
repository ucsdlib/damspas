require 'spec_helper'

describe DamsEventDatastream do

  describe "event model" do

    describe "instance populated in-memory" do

      subject { DamsEventDatastream.new(stub('inner object', :pid=>'bbXXXXXX24', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXX24"
      end

      it "should have a type" do
        subject.type = "collection creation"
        subject.type.should == ["collection creation"]
      end

      it "should have an eventDate" do
        subject.eventDate = "2012-11-06T09:26:34-0500"
        subject.eventDate.should == ["2012-11-06T09:26:34-0500"]
      end

      it "should have an outcome" do
        subject.outcome = "success"
        subject.outcome.should == ["success"]
      end
      
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = DamsEventDatastream.new(stub('inner object', :pid=>'bb28282828', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsEvent.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb28282828"
      end

      it "should have a type" do
        subject.type.should == ["collection creation"]
      end

      it "should have an eventDate" do
        subject.eventDate.should == ["2012-11-06T09:26:34-0500"]
      end

      it "should have an outcome" do
        subject.outcome.should == ["success"]
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["type_tesim"].should == ["collection creation"]
        solr_doc["eventDate_tesim"].should == ["2012-11-06T09:26:34-0500"]
        solr_doc["outcome_tesim"].should == ["success"]
      end   
      
      it "should have relationship" do
        subject.relationship.first.name.first.pid.should == "bb08080808"
        subject.relationship.first.role.first.pid.should == "bd55639754"
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should == ["Artist, Alice, 1966-"]
        solr_doc["role_tesim"].should == ["Creator"]
        solr_doc["role_code_tesim"].should == ["cre"]
        solr_doc["role_externalAuthority_tesim"].should == ["http://id.loc.gov/vocabulary/relators/cre"]
      end
    end
  end
end
