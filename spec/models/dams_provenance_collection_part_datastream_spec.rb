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
 	  it "should have scopeContentNote" do
		testIndexNoteFields "scopeContentNote","bd1366006j","scope_and_content","Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.","Scope and contents"
      end

 	  it "should have notes" do
        solr_doc = subject.to_solr
        solr_doc["note_1_value_tesim"].should == ["This is some text to describe the basic contents of the object."]
        solr_doc["note_1_id_tesim"].should == ["bd52568274"]
        solr_doc["note_2_value_tesim"].should == ["Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."]
        solr_doc["note_3_value_tesim"].should == ["http://libraries.ucsd.edu/ark:/20775/bb80808080"]
      end
      
      it "should have preferredCitationNote" do
		testIndexNoteFields "preferredCitationNote","bd3959888k","citation","\"Data at Redshift=1.4 (RD0022).\"  From: Rick Wagner, Eric J. Hallman, Brian W. O'Shea, Jack O. Burns, Michael L. Norman, Robert Harkness, and Geoffrey So.  \"The Santa Fe Light Cone Simulation research project files.\"  UC San Diego Research Cyberinfrastructure Data Curation. (Data version 1.0, published 2013; http://dx.doi.org/10.5060/&&&&&&&&)","Citation"
      end    
      it "should have CustodialResponsibilityNote" do
		testIndexNoteFields "custodialResponsibilityNote","bd9113515d","custodial_history","Mandeville Special Collections Library, University of California, San Diego, La Jolla, 92093-0175 (http://libraries.ucsd.edu/locations/mscl/)","Digital object made available by"
      end  
      it "should have relationship" do
        subject.relationship.first.name.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bb08080808"
        subject.relationship.first.role.first.to_s.should == "http://library.ucsd.edu/ark:/20775/bd55639754"
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should == ["Artist, Alice, 1966-"]
        solr_doc["role_tesim"].should == ["Creator"]
        solr_doc["role_code_tesim"].should == ["cre"]
        solr_doc["role_valueURI_tesim"].should == ["http://id.loc.gov/vocabulary/relators/cre"]
      end       
      def testIndexNoteFields (fieldName,id,type,value,displayLabel) 
        solr_doc = subject.to_solr
        solr_doc["#{fieldName}_1_id_tesim"].should == ["#{id}"]
        solr_doc["#{fieldName}_1_type_tesim"].should == ["#{type}"]
        solr_doc["#{fieldName}_1_value_tesim"].should == ["#{value}"]
        solr_doc["#{fieldName}_1_displayLabel_tesim"].should == ["#{displayLabel}"]
      end    	 
    end
  end
end
