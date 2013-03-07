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
      cList[2].should be_kind_of MadsComplexSubjectDatastream::ComponentList::GenreForm
      cList[2].name.should == ["Film and video adaptions"]      
      cList.size.should == 5
    end
    
    it "should have topic from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["complexSubject_0_topic_tesim"].should == ["Galaxies"]
        solr_doc["complexSubject_0_0_topic_tesim"].should == ["Galaxies"]
        solr_doc["complexSubject_1_topic_tesim"].should == ["Clusters"]
        solr_doc["complexSubject_1_0_topic_tesim"].should == ["Clusters"]
         #external topic
        solr_doc["complexSubject_4_topic_tesim"].should == ["Baseball"]  
        solr_doc["complexSubject_4_0_topic_tesim"].should == ["Baseball"]
    end    
    it "should have genreForm from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["complexSubject_2_genreForm_tesim"].should == ["Film and video adaptions"]
        solr_doc["complexSubject_2_0_genreForm_tesim"].should == ["Film and video adaptions"]
        #external genreForm
        solr_doc["complexSubject_3_genreForm_tesim"].should == ["Film and video adaptions"]  
        solr_doc["complexSubject_3_0_genreForm_tesim"].should == ["Film and video adaptions"]
    end         
  end  
end
