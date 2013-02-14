require 'spec_helper'

describe DamsProvenanceCollectionPartDatastream do

  describe "a provenance collection part model" do

    describe "instance populated in-memory" do

      subject { DamsProvenanceCollectionPartDatastream.new(stub('inner object', :pid=>'bb25252525', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb25252525"
      end
      it "should have a title" do
        subject.title.build.value = "May 2009"
        subject.title.first.value.should == ["May 2009"]
      end
      it "should have a date" do
        subject.date.build.value = "2009-05-03"
        subject.date.first.value.should == ["2009-05-03"]
      end
#      it "should have a language" do
#        subject.language.build.rdf_subject = "http://library.ucsd.edu/ark:/20775/bd0410344f"
#        subject.language.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bd0410344f"
#      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsProvenanceCollectionPartDatastream.new(stub('inner object', :pid=>'bb25252525', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsProvenanceCollectionPart.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb25252525"
      end
      it "should have a title" do
        subject.title.first.value.should == ["May 2009"]
      end
      it "should have a date" do
        subject.date.first.beginDate.should == ["2009-05-03"]
        subject.date.first.endDate.should == ["2009-05-31"]
      end
#      it "should have a language" do
#        subject.language.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bd0410344f"
#      end
    end
  end
end
