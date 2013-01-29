require 'spec_helper'

describe DamsSubjectDatastream do
  describe "an instance with content" do
    subject do
      subject = DamsSubjectDatastream.new(stub('inner object', :pid=>'bbXXXXXXX5', :new? =>true), 'descMetadata')
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
      subject = DamsSubjectDatastream.new(stub('inner object', :pid=>'bbXXXXXXX5', :new? =>true), 'descMetadata')
      subject.content = File.new('spec/fixtures/madsMoreComplexSubject.rdf.xml').read
      subject
    end
    it "should have a subject" do
      subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX5"
    end

    it "should have fields" do
      list = subject.elementList.first
      list.first.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX6"
      list[1].should be_kind_of DamsSubjectDatastream::List::TopicElement
      list[1].elementValue.should == ["Relations with Mexican Americans"]
      list[2].should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXX4"
      list[3].should be_kind_of DamsSubjectDatastream::List::TemporalElement
      list[3].elementValue.should == ["20th century"]
      list.size.should == 4
    end
  end
end
