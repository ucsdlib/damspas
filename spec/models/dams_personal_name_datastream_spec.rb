# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsPersonalNameDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsPersonalNameDatastream.new(stub('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "http://library.ucsd.edu/ark:/20775/bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Maria"
        subject.name.should == ["Maria"]
      end
      
    end

    describe "an instance with content" do
      subject do
        subject = DamsPersonalNameDatastream.new(stub('inner object', :pid=>'bb09090909', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsPersonalName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Administrator, Bob, 1977-"]
      end

    end
  end
end
