require 'spec_helper'

describe DamsAssembledCollectionDatastream do

  describe "an assembled collection model" do

    describe "instance populated in-memory" do

      subject { DamsAssembledCollectionDatastream.new(double('inner object', :pid=>'xx03030303', :new_record? => true), 'damsMetadata') }

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}xx03030303")
      end
      it "should have a title" do
        subject.titleValue = "UCSD Electronic Theses and Dissertations"
        expect(subject.titleValue).to eq("UCSD Electronic Theses and Dissertations")
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
        subject = DamsAssembledCollectionDatastream.new(double('inner object', :pid=>'xx03030303', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsAssembledCollection2.rdf.xml').read
        subject
      end

      before(:all) do
        @part1 = DamsProvenanceCollectionPart.create(pid: 'xx25252525', titleValue: 'May 2009', visibility: 'public', relatedResource_attributes: [{type: 'thumbnail', uri: 'http://pontos.ucsd.edu/images/dmca.jpg'}])
        @part2 = DamsProvenanceCollectionPart.create(pid: 'xx6110278b', titleValue: 'Sample Provenance Part', visibility: 'public', relatedResource_attributes: [{type: 'thumbnail', uri: 'http://pontos.ucsd.edu/images/newsrel.jpg'}])
        @prov1 = DamsProvenanceCollection.create(pid: 'xx24242424', titleValue: 'Historical Dissertations', provenanceCollectionPartURI: @part1.pid, visibility: 'public', relatedResource_attributes: [{type: 'thumbnail', uri: 'http://pontos.ucsd.edu/images/siogeo.jpg'}]) 
        @prov2 = DamsProvenanceCollection.create(pid: 'xx24241158', titleValue: 'Scripps Institution of Oceanography, Geological Collections', visibility: 'public', relatedResource_attributes: [{type: 'thumbnail', uri: 'http://pontos.ucsd.edu/images/siogeo.jpg'}] )
        @lang = MadsAuthority.create(pid: 'xx0410344f', name: 'English', code: 'eng')
      end
      after(:all) do
        @prov1.delete
        @prov2.delete
        @part1.delete
        @part2.delete
        @lang.delete
      end

      it "should have a subject" do
        expect(subject.rdf_subject.to_s).to eq("#{Rails.configuration.id_namespace}xx03030303")
      end
      it "should have a title" do
        expect(subject.titleValue).to eq("UCSD Electronic Theses and Dissertations")
      end
      it "should have a date" do
        expect(subject.beginDate).to eq(["2009-05-03"])
      end
      it "should have a visibility" do
        expect(subject.visibility).to eq(["public"])
      end
      it "should have a resource_type" do
        expect(subject.resource_type).to eq(["text"])
      end

 	  it "should index title and dates" do
        solr_doc = subject.to_solr
        expect(solr_doc["title_tesim"]).to eq(["UCSD Electronic Theses and Dissertations"])
        expect(solr_doc["date_tesim"]).to eq(["2009-05-03"])
        expect(solr_doc["visibility_tesim"]).to eq(["public"])
        expect(solr_doc["resource_type_tesim"]).to eq(["text"])
      end

 	  it "should have notes" do
        solr_doc = subject.to_solr

        # generic notes
        expect(solr_doc["note_tesim"].to_s).to include "Inline generic note"
        expect(solr_doc["note_tesim"].to_s).to include "Linked generic note"

        # custodial responsibility notes
		expect(solr_doc["custodialResponsibilityNote_tesim"].to_s).to include "Inline custodial responsibility note"
		expect(solr_doc["custodialResponsibilityNote_tesim"].to_s).to include "Linked custodial responsibility note"

        # preferred citation notes
		expect(solr_doc["preferredCitationNote_tesim"].to_s).to include "Inline preferred citation note"
		expect(solr_doc["preferredCitationNote_tesim"].to_s).to include "Linked preferred citation note"

        # scope content notes
        expect(solr_doc["scopeContentNote_tesim"].to_s).to include "Inline scope content note"
        expect(solr_doc["scopeContentNote_tesim"].to_s).to include "Linked scope content note"
      end

      it "should have relationship" do
        expect(subject.relationship.first.personalName.first.pid).to eq("bb08080808")
        expect(subject.relationship.first.role.first.pid).to eq("bd55639754")
        solr_doc = subject.to_solr
        expect(solr_doc["name_tesim"]).to eq(["Artist, Alice, 1966-"])
      end

      it "should index parts" do
        solr_doc = subject.to_solr
        expect(solr_doc["provenanceCollection_name_tesim"]).to eq(["Historical Dissertations"])
        expect(solr_doc["provenanceCollection_id_tesim"]).to eq(["xx24242424"])
        expect(solr_doc["provenanceCollection_json_tesim"]).to eq(['{"id":"xx24242424","name":"Historical Dissertations","visibility":"public","thumbnail":"http://pontos.ucsd.edu/images/siogeo.jpg"}', '{"id":"xx24241158","name":"Scripps Institution of Oceanography, Geological Collections","visibility":"public","thumbnail":"http://pontos.ucsd.edu/images/siogeo.jpg"}'])
        expect(solr_doc["part_name_tesim"]).to eq(["May 2009"])
        expect(solr_doc["part_id_tesim"]).to eq(["xx25252525"])
        expect(solr_doc["part_json_tesim"]).to eq(['{"id":"xx25252525","name":"May 2009","visibility":"public","thumbnail":"http://pontos.ucsd.edu/images/dmca.jpg"}', '{"id":"xx6110278b","name":"Sample Provenance Part","visibility":"public","thumbnail":"http://pontos.ucsd.edu/images/newsrel.jpg"}'])		
		expect(solr_doc["unit_code_tesim"]).to eq(["rdcp"])
      end

#      it "should have event" do
#        solr_doc = subject.to_solr
#        solr_doc["event_1_type_tesim"].should == ["collection creation"]
#        solr_doc["event_1_eventDate_tesim"].should == ["2012-11-06T09:26:34-0500"]
#        solr_doc["event_1_outcome_tesim"].should == ["success"]
#        solr_doc["event_1_name_tesim"].should == ["Administrator, Bob, 1977-"]
#        solr_doc["event_1_role_tesim"].should == ["Initiator"]
#      end
    end
  end
end
