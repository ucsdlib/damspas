require 'spec_helper'

describe DamsProvenanceCollectionPartDatastream do

  describe "a provenance collection part model" do

    describe "instance populated in-memory" do

      subject { DamsProvenanceCollectionPartDatastream.new(double('inner object', :pid=>'bb25252525', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb25252525"
      end
      it "should have a title" do
        subject.titleValue = "May 2009"
        subject.titleValue.should == "May 2009"
      end
      it "should have a date" do
        subject.dateValue = "2009-05-03"
        subject.dateValue.should == ["2009-05-03"]
      end
#      it "should have a language" do
#        subject.language.build.rdf_subject = "#{Rails.configuration.id_namespace}bd0410344f"
#        subject.language.first.to_s.should == "#{Rails.configuration.id_namespace}bd0410344f"
#      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsProvenanceCollectionPartDatastream.new(double('inner object', :pid=>'bb25252525', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsProvenanceCollectionPart.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb25252525"
      end
      it "should have a title" do
        subject.titleValue.should == "May 2009"
      end
      it "should have a date" do
        subject.beginDate.should == ["2009-05-03"]
        subject.endDate.should == ["2009-05-31"]
      end

 	  it "should have notes" do
        solr_doc = subject.to_solr
        solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "#{Rails.configuration.id_namespace}bb80808080"
        solr_doc["note_tesim"].should include "Linked note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end
      
      it "should have index notes" do
        solr_doc = subject.to_solr

 	    #it "should have scopeContentNote" do
		testIndexNoteFields solr_doc, "scopeContentNote","Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."

        #it "should have preferredCitationNote" do
		testIndexNoteFields solr_doc,"preferredCitationNote","Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."

        #it "should have CustodialResponsibilityNote" do
		testIndexNoteFields solr_doc, "custodialResponsibilityNote","Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end  
      it "should have relationship" do
        subject.relationship.first.name.first.pid.should == "bb08080808"
        subject.relationship.first.role.first.pid.should == "bd55639754"
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should include "Artist, Alice, 1966-"
      end       
      def testIndexNoteFields (solr_doc,fieldName,value)
        solr_doc["#{fieldName}_tesim"].should include "#{value}"
      end    	 
    end
  end
end
