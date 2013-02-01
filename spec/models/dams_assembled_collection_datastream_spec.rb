require 'spec_helper'

describe DamsAssembledCollectionDatastream do

  describe "an assembled collection model" do

    describe "instance populated in-memory" do

      subject { DamsAssembledCollectionDatastream.new(stub('inner object', :pid=>'bb03030303', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.repository_root}bb03030303"
      end
      it "should have a title" do
        subject.title.build.value = "UCSD Electronic Theses and Dissertations"
        subject.title.first.value.should == ["UCSD Electronic Theses and Dissertations"]
      end
      it "should have a date" do
        subject.date.build.value = "2009-05-03"
        subject.date.first.value.should == ["2009-05-03"]
      end
      it "should have a note" do
        subject.note.build.value = "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        subject.note.first.value.should == ["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."]
      end
#      it "should have a language" do
#        subject.language.build.rdf_subject = "http://library.ucsd.edu/ark:/20775/bd0410344f"
#        subject.language.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bd0410344f"
#      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsAssembledCollectionDatastream.new(stub('inner object', :pid=>'bb03030303', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsAssembledCollection.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.repository_root}bb03030303"
      end
      it "should have a title" do
        subject.title.first.value.should == ["UCSD Electronic Theses and Dissertations"]
      end
      it "should have a date" do
        subject.date.first.beginDate.should == ["2009-05-03"]
      end
      it "should have a note" do
        subject.note.first.value.should == ["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."]
      end
#      it "should have a language" do
#        subject.language.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bd0410344f"
#      end
    end
  end
end
