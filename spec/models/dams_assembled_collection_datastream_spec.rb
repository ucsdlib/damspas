require 'spec_helper'

describe DamsAssembledCollectionDatastream do

  describe "an assembled collection model" do

    describe "instance populated in-memory" do

      subject { DamsAssembledCollectionDatastream.new(stub('inner object', :pid=>'bb03030303', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb03030303"
      end
      it "should have a title" do
        subject.title.build.value = "UCSD Electronic Theses and Dissertations"
        subject.title.first.value.should == ["UCSD Electronic Theses and Dissertations"]
      end
      it "should have a date" do
        subject.date.build.value = "2009-05-03"
        subject.date.first.value.should == ["2009-05-03"]
      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsAssembledCollectionDatastream.new(stub('inner object', :pid=>'bb03030303', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsAssembledCollection.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb03030303"
      end
      it "should have a title" do
        subject.title.first.value.should == ["UCSD Electronic Theses and Dissertations"]
      end
      it "should have a date" do
        subject.date.first.beginDate.should == ["2009-05-03"]
      end
      
 	  it "should have scopeContentNote" do
        solr_doc = subject.to_solr
        solr_doc["scopeContentNote_1_id_tesim"].should == ["bd1366006j"]
        solr_doc["scopeContentNote_1_type_tesim"].should == ["scope_and_content"]
        solr_doc["scopeContentNote_1_value_tesim"].should == ["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."]
        solr_doc["scopeContentNote_1_displayLabel_tesim"].should == ["Scope and contents"]
      end

 	  it "should have notes" do
        solr_doc = subject.to_solr
        solr_doc["note_1_value_tesim"].should == ["This is some text to describe the basic contents of the object."]
        solr_doc["note_1_id_tesim"].should == ["bd52568274"]
        solr_doc["note_2_value_tesim"].should == ["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."]
        solr_doc["note_3_value_tesim"].should == ["http://libraries.ucsd.edu/ark:/20775/bb80808080"]
      end

    end
  end
end
