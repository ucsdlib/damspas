require 'spec_helper'

describe DamsProvenanceCollectionDatastream do

  describe "a provenance collection model" do

    describe "instance populated in-memory" do

      subject { DamsProvenanceCollectionDatastream.new(double('inner object', :pid=>'bb24242424', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb24242424"
      end
      it "should have a title" do
        subject.titleValue = "Historical Dissertations"
        subject.titleValue.should == "Historical Dissertations"
      end
      it "should have a date" do
        subject.dateValue = "2009-05-03"
        subject.dateValue.should == ["2009-05-03"]
      end
      it "should have a visibility" do
        subject.visibility = "public"
        subject.visibility.should == ["public"]
      end
      it "should have a resource_type" do
        subject.resource_type = "text"
        subject.resource_type.should == ["text"]
      end
  #    it "should have a language" do
  #      subject.language.build.rdf_subject = "#{Rails.configuration.id_namespace}bd0410344f"
  #     subject.language.first.to_s.should == "#{Rails.configuration.id_namespace}bd0410344f"
  #    end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsProvenanceCollectionDatastream.new(double('inner object', :pid=>'bb24242424', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsProvenanceCollection.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb24242424"
      end
      it "should have a title" do
        subject.titleValue.should == "Historical Dissertations"
      end
      it "should have a date" do
        subject.beginDate.should == ["2009-05-03"]
        subject.endDate.should == ["2010-06-30"]
      end
      it "should have a visibility" do
        subject.visibility.should == ["public"]
      end
      it "should have a resource_type" do
        subject.resource_type.should == ["text"]
      end
 #     it "should have a language" do
 #       subject.language.first.to_s.should == "#{Rails.configuration.id_namespace}bd0410344f"
 #     end

#     it "should have notes" do
#        solr_doc = subject.to_solr
#        solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
#        solr_doc["note_tesim"].should include "#{Rails.configuration.id_namespace}bb80808080"
#       solr_doc["note_tesim"].should include "Linked note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
#        solr_doc["note_tesim"].should include "Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
#        solr_doc["note_tesim"].should include "Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
#      end
      
#     it "should index notes" do
#       solr_doc = subject.to_solr

      #it "should have scopeContentNote" do
#   testIndexNoteFields solr_doc,"scopeContentNote","Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."

        #it "should have preferredCitationNote" do
#   testIndexNoteFields solr_doc,"preferredCitationNote","Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."

        #it "should have CustodialResponsibilityNote" do
#   testIndexNoteFields solr_doc,"custodialResponsibilityNote","Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
#      end  
 #     it "should have relationship" do
 #       subject.relationship.first.name.first.pid.should == "bb08080808"
 #       subject.relationship.first.role.first.pid.should == "bd55639754"
 #       solr_doc = subject.to_solr
 #       solr_doc["name_tesim"].should include "Artist, Alice, 1966-"
 #     end 

#      it "should have event" do
#        solr_doc = subject.to_solr
#        solr_doc["event_1_type_tesim"].should == ["collection creation"]
#        solr_doc["event_1_eventDate_tesim"].should == ["2012-11-06T09:26:34-0500"]
#        solr_doc["event_1_outcome_tesim"].should == ["success"]
#        solr_doc["event_1_name_tesim"].should == ["Administrator, Bob, 1977-"]
#        solr_doc["event_1_role_tesim"].should == ["Initiator"]
#      end              
#      def testIndexNoteFields (solr_doc,fieldName,value)
#        solr_doc["#{fieldName}_tesim"].should include value
#      end    
      it "should index parts" do
        solr_doc = subject.to_solr
        solr_doc["part_name_tesim"].should == ["May 2009"]
        solr_doc["part_id_tesim"].should == ["bb25252525"]
        solr_doc["part_json_tesim"].should == ['{"id":"bb25252525","name":"May 2009","thumbnail":"http://pontos.ucsd.edu/images/dmca.jpg"}', '{"id":"bd6110278b","name":"Sample Provenance Part","thumbnail":"http://pontos.ucsd.edu/images/newsrel.jpg"}']
      end
    end
  end
end
