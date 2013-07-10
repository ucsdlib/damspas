require 'spec_helper'

describe MadsAuthorityDatastream do
  describe "a MADS Authority model" do

    describe "instance populated in-memory" do

      subject { MadsAuthorityDatastream.new(stub('inner object', :pid=>'bd8396905c', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd8396905c"
      end

      it "should have a name" do
        subject.name = "Test Authority Name"
        subject.name.should == ["Test Authority Name"]
      end

      it "should have a code" do
        subject.code = "Test Authority Code"
        subject.code.should == ["Test Authority Code"]
      end

      it "should have a description" do
        subject.code = "Test Authority Description"
        subject.code.should == ["Test Authority Description"]
      end

      it "should have a scheme" do
        subject.scheme = "bd0683587d"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd0683587d"
      end
    end

    describe "an instance loaded from fixture xml" do

      subject do
        subject = MadsAuthorityDatastream.new(stub('inner object', :pid=>'bd8396905c', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsAuthority.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd8396905c"
      end

      it "should have a name" do
        subject.name.should == ["Repository"]
      end

      it "should have a code" do
        subject.code.should == ["rps"]
      end

      it "should have a description" do
        subject.description.should == ["An organization that hosts data or material culture objects and provides services to promote long term, consistent and shared use of those data or objects."]
      end

      it "should have a scheme" do
        subject.scheme.should == "#{Rails.configuration.id_namespace}bd9386739x"
      end

      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["code_tesim"].should == ["rps"]
        solr_doc["name_tesim"].should == ["Repository"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd9386739x"]
        solr_doc["scheme_name_tesim"].should == ["Library of Congress Subject Headings"]
        solr_doc["scheme_code_tesim"].should == ["lcsh"]
        solr_doc["externalAuthority_tesim"].should == ["http://id.loc.gov/vocabulary/relators/rps"]
      end    
    end
  end
end
