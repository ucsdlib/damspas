# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsPersonDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsPersonDatastream.new(stub('inner object', :pid=>'test:1', :new? =>true), 'damsMetadata', about:"http://library.ucsd.edu/ark:/20775/") }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/"
      end
      
    end

    describe "an instance with content" do
      subject do
        subject = DamsPersonDatastream.new(stub('inner object', :pid=>'test:1', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/personalNameRdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Administrator, Bob, 1977-"]
      end

    end
  end
end
