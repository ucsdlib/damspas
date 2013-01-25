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
end
