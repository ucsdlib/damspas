require 'spec_helper'

describe DamsComponentDatastream do

  describe "a component model" do

    describe "instance populated in-memory" do

      subject { DamsComponentDatastream.new(stub('inner object', :pid=>'zz12345678', :new? => true), 'damsMetadata') }

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}zz12345678"
      end
      it "should have a title" do
        subject.titleValue = "The Static Image"
        subject.titleValue.should == ["The Static Image"]
      end
      it "should have a date" do
        subject.dateValue = "2012-06-24"
        subject.dateValue.should == ["2012-06-24"]
      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsComponentDatastream.new(stub('inner object', :pid=>'zz12345678', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsComponent.rdf.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}zz12345678"
      end
      it "should have a title" do
        subject.titleValue.should == ["The Static Image"]
      end
      it "should have a date" do
        subject.beginDate.should == ["2012-06-24"]
      end

 	  it "should index title and dates" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].first.should == "The Static Image"
        solr_doc["title_1_value_tesim"].should == ["The Static Image"]
        solr_doc["date_1_beginDate_tesim"].should == ["2012-06-24"]
     	#solr_doc["date_1_endDate_tesim"].should == ["2012-06-25"]
     	#solr_doc["date_1_value_tesim"].should == ["June 24-25, 2012"]
      end

 	  it "should have notes" do
        solr_doc = subject.to_solr
        solr_doc["note_1_value_tesim"].should == ["1 PDF (xi, 111 p.)"]
        solr_doc["note_1_displayLabel_tesim"].should == ["Extent"]
        solr_doc["note_1_type_tesim"].should == ["dimensions"]
      end                

    end
  end
end
