require 'spec_helper'

describe DamsProvenanceCollectionPartDatastream do

  describe "a provenance collection part model" do

    describe "instance populated in-memory" do

      subject { DamsProvenanceCollectionPartDatastream.new(stub('inner object', :pid=>'bb25252525', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb25252525"
      end
      it "should have a title" do
        subject.titleValue = "May 2009"
        subject.titleValue.should == ["May 2009"]
      end
      it "should have a date" do
        subject.dateValue = "2009-05-03"
        subject.dateValue.should == ["2009-05-03"]
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
        subject.titleValue.should == ["May 2009"]
      end
      it "should have a date" do
        subject.beginDate.should == ["2009-05-03"]
        subject.endDate.should == ["2009-05-31"]
      end

 	  it "should have notes" do
        solr_doc = subject.to_solr
        solr_doc["note_tesim"].should include "This is some text to describe the basic contents of the object."
        solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "http://libraries.ucsd.edu/ark:/20775/bb80808080"
      end
      
      it "should have index notes" do
        solr_doc = subject.to_solr

 	    #it "should have scopeContentNote" do
		testIndexNoteFields solr_doc, "scopeContentNote","Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."

        #it "should have preferredCitationNote" do
		testIndexNoteFields solr_doc,"preferredCitationNote","\"Data at Redshift=1.4 (RD0022).\"  From: Rick Wagner, Eric J. Hallman, Brian W. O'Shea, Jack O. Burns, Michael L. Norman, Robert Harkness, and Geoffrey So.  \"The Santa Fe Light Cone Simulation research project files.\"  UC San Diego Research Cyberinfrastructure Data Curation. (Data version 1.0, published 2013; http://dx.doi.org/10.5060/&&&&&&&&)"

        #it "should have CustodialResponsibilityNote" do
		testIndexNoteFields solr_doc, "custodialResponsibilityNote","Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://libraries.ucsd.edu/locations/mscl/)"
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
