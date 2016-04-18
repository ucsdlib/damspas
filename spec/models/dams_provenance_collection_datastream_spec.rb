require 'spec_helper'

describe DamsProvenanceCollectionDatastream do

  describe "a provenance collection model" do

    describe "instance populated in-memory" do

      subject { DamsProvenanceCollectionDatastream.new(double('inner object', :pid=>'bb24242424', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bb24242424")
      end
      it "should have a title" do
        subject.titleValue = "Historical Dissertations"
        expect(subject.titleValue).to eq("Historical Dissertations")
      end
      it "should have a date" do
        subject.dateValue = "2009-05-03"
        expect(subject.dateValue).to eq(["2009-05-03"])
      end
      it "should have a visibility" do
        subject.visibility = "public"
        expect(subject.visibility).to eq(["public"])
      end
      it "should have a resource_type" do
        subject.resource_type = "text"
        expect(subject.resource_type).to eq(["text"])
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
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}bb24242424")
      end
      it "should have a title and variant titles" do
        expect(subject.titleValue).to eq("Historical Dissertations")
        expect(subject.titleVariant).to eq(["The Whale 2", "The Whale"])
        expect(subject.titleTranslationVariant).to eq(["Translation Variant 2", "Translation Variant"])
	    expect(subject.titleAbbreviationVariant).to eq(["Abbreviation Variant 2", "Abbreviation Variant"])
	    expect(subject.titleAcronymVariant).to eq(["Acronym Variant 2", "Acronym Variant"])
	    expect(subject.titleExpansionVariant).to eq(["Expansion Variant 2", "Expansion Variant"])        
      end
      it "should have a date" do
        expect(subject.beginDate).to eq(["2009-05-03"])
        expect(subject.endDate).to eq(["2010-06-30"])
      end
      it "should have a visibility" do
        expect(subject.visibility).to eq(["public"])
      end
      it "should have a resource_type" do
        expect(subject.resource_type).to eq(["text"])
      end

      it "should index parts" do
        solr_doc = subject.to_solr
        expect(solr_doc["part_name_tesim"]).to eq(["May 2009"])
        expect(solr_doc["part_id_tesim"]).to eq(["xx25252525"])
        expect(solr_doc["part_json_tesim"]).to eq(['{"id":"xx25252525","name":"May 2009","visibility":"public","thumbnail":[]}', '{"id":"xx6110278b","name":"Sample Provenance Part","visibility":"public","thumbnail":[]}'])
		expect(solr_doc["unit_code_tesim"]).to eq(["dlp"])
      end
      
      it "should index variant titles" do
        solr_doc = subject.to_solr
        expect(solr_doc["titleVariant_tesim"]).to eq(["The Whale 2", "The Whale"])
        expect(solr_doc["titleTranslationVariant_tesim"]).to eq(["Translation Variant 2", "Translation Variant"])
        expect(solr_doc["titleAbbreviationVariant_tesim"]).to eq(["Abbreviation Variant 2", "Abbreviation Variant"])
        expect(solr_doc["titleAcronymVariant_tesim"]).to eq(["Acronym Variant 2", "Acronym Variant"])
        expect(solr_doc["titleExpansionVariant_tesim"]).to eq(["Expansion Variant 2", "Expansion Variant"])      
     end
    end
  end
end
