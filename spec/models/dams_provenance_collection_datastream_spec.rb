require 'spec_helper'

describe DamsProvenanceCollectionDatastream do

  describe "a provenance collection model" do

    describe "instance populated in-memory" do

      subject { DamsProvenanceCollectionDatastream.new(double('inner object', :pid=>'bb24242424', :new_record? => true), 'damsMetadata') }

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
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsProvenanceCollectionDatastream.new(double('inner object', :pid=>'bb24242424', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsProvenanceCollection.rdf.xml').read
        subject
      end
      before(:all) do
        @part1 = DamsProvenanceCollectionPart.create pid: 'xx25252525', titleValue: "May 2009", visibility: 'public'
        @part2 = DamsProvenanceCollectionPart.create pid: 'xx6110278b', titleValue: "Sample Provenance Part", visibility: 'public'
        @parent = DamsAssembledCollection.create pid: 'xx03030303', titleValue: "UCSD Electronic Theses and Dissertations", visibility: 'public'
      end
      after(:all) do
        @parent.delete
        @part1.delete
        @part2.delete
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb24242424"
      end
      it "should have a title and variant titles" do
        subject.titleValue.should == "Historical Dissertations"
        subject.titleVariant.should == ["The Whale 2", "The Whale"]
        subject.titleTranslationVariant.should == ["Translation Variant 2", "Translation Variant"]
	    subject.titleAbbreviationVariant.should == ["Abbreviation Variant 2", "Abbreviation Variant"]
	    subject.titleAcronymVariant.should == ["Acronym Variant 2", "Acronym Variant"]
	    subject.titleExpansionVariant.should == ["Expansion Variant 2", "Expansion Variant"]        
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

      it "should index parts" do
        solr_doc = subject.to_solr
        solr_doc["part_name_tesim"].should == ["May 2009"]
        solr_doc["part_id_tesim"].should == ["xx25252525"]
        solr_doc["part_json_tesim"].should == ['{"id":"xx25252525","name":"May 2009","visibility":"public","thumbnail":[]}', '{"id":"xx6110278b","name":"Sample Provenance Part","visibility":"public","thumbnail":[]}']
		solr_doc["unit_code_tesim"].should == ["dlp"]
      end
      
      it "should index variant titles" do
        solr_doc = subject.to_solr
        solr_doc["titleVariant_tesim"].should == ["The Whale 2", "The Whale"]
        solr_doc["titleTranslationVariant_tesim"].should == ["Translation Variant 2", "Translation Variant"]
        solr_doc["titleAbbreviationVariant_tesim"].should == ["Abbreviation Variant 2", "Abbreviation Variant"]
        solr_doc["titleAcronymVariant_tesim"].should == ["Acronym Variant 2", "Acronym Variant"]
        solr_doc["titleExpansionVariant_tesim"].should == ["Expansion Variant 2", "Expansion Variant"]      
     end
    end
  end
end
