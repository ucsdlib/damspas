require 'spec_helper'

describe MadsComplexSubjectDatastream do
  describe "an instance with content" do
    subject do
      subject = MadsComplexSubjectDatastream.new(stub('inner object', :pid=>'bbXXXXXXX5', :new? =>true), 'descMetadata')
      subject.content = File.new('spec/fixtures/madsComplexSubject.xml').read
      subject
    end
    it "should have a subject" do
      subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX5"
    end

    it "should have fields" do
      subject.name.should == ["Academic dissertations"]
    end
  end
  describe "an instance with an element list" do
    subject do
      subject = MadsComplexSubjectDatastream.new(stub('inner object', :pid=>'bbXXXXXXX5', :new? =>true), 'descMetadata')
      subject.content = File.new('spec/fixtures/madsMoreComplexSubject.rdf.xml').read
      subject
    end
    it "should have a subject" do
      subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX5"
    end

    it "should have fields" do
      list = subject.elementList.first
      list.first.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX6"
     # list[1].should be_kind_of MadsComplexSubjectDatastream::ComponentList::Topic::ElementList::TopicElement
      list[1].elementValue.should == ["Relations with Mexican Americans"]
      list[2].should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX4"
      list[3].should be_kind_of MadsComplexSubjectDatastream::List::TemporalElement
      list[3].elementValue.should == ["20th century"]
      list.size.should == 4
    end
  end
  
  describe "an instance with an component list" do
     subject do
        subject = MadsComplexSubjectDatastream.new(stub('inner object', :pid=>'bd6724414c', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsMoreComplexSubject2.rdf.xml').read
        subject
      end
            
      it "should have name" do
        subject.name.should == ["Galaxies--Clusters"]
      end
 
      it "should have an authority" do
        subject.authority.should == ["lcsh"]
      end

    it "should have fields" do
      cList = subject.componentList.first
      cList[0].should be_kind_of MadsComplexSubjectDatastream::ComponentList::Topic
      cList[0].name.should == ["Galaxies"]
      cList[1].should be_kind_of MadsComplexSubjectDatastream::ComponentList::Topic
      cList[1].name.should == ["Clusters"]
      cList.size.should == 2
    end
    
    it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["topic_0_tesim"].should == ["Galaxies"]
        solr_doc["topic_element_0_0_tesim"].should == ["Galaxies"]
        solr_doc["topic_1_tesim"].should == ["Clusters"]
        solr_doc["topic_element_1_0_tesim"].should == ["Clusters"]
      end     
  end  
end
