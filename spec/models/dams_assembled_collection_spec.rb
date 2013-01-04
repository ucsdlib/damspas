require 'spec_helper'

describe DamsAssembledCollectionDatastream do
   describe "with new datastream" do
      before do
    	@damsDS = DamsAssembledCollectionDatastream.new(nil,'damsAssembledCollection')
      end
     it "should have titleType" do
       test_attribute_xpath(@damsDS, 'titleType', '//dams:AssembledCollection/dams:title/dams:Title/dams:type')
     end

     it "should have title" do
       test_attribute_xpath(@damsDS, 'title', '//dams:AssembledCollection/dams:title/dams:Title/rdf:value')
     end

     it "should have beginDate" do
       test_attribute_xpath(@damsDS, 'beginDate', '//dams:AssembledCollection/dams:date/dams:Date/dams:beginDate')
     end

     it "should have language" do
       test_attribute_xpath(@damsDS, 'language', '//dams:AssembledCollection/dams:language/@rdf:resource')
     end

     it "should have note" do
       test_attribute_xpath(@damsDS, 'note', '//dams:AssembledCollection/dams:note/dams:ScopeContentNote/rdf:value')
     end

     it "should have noteDisplayLabel" do
       test_attribute_xpath(@damsDS, 'noteDisplayLabel', '//dams:AssembledCollection/dams:note/dams:ScopeContentNote/dams:displayLabel')
     end

     it "should have noteType" do
       test_attribute_xpath(@damsDS, 'noteType', '//dams:AssembledCollection/dams:note/dams:ScopeContentNote/dams:type')
     end
     it "should have relatedCollection" do
       test_attribute_xpath(@damsDS, 'relatedCollection', '//dams:AssembledCollection/dams:relatedCollection/@rdf:resource')
     end

     it "should have hasProvenanceCollection" do
       test_attribute_xpath(@damsDS, 'hasProvenanceCollection', '//dams:AssembledCollection/dams:hasProvenanceCollection/@rdf:resource')
     end

     it "should have event" do
       test_attribute_xpath(@damsDS, 'event', '//dams:AssembledCollection/dams:event/@rdf:resource')
     end

   end

   describe "with existing datastream" do
     before do
       file = File.new(File.join(File.dirname(__FILE__),'..' ,'fixtures', "damsAssembledCollection.xml"))
       @damsDS = DamsAssembledCollectionDatastream.from_xml(file)
     end

     it "should have titleType" do
       test_existing_attribute(@damsDS, 'titleType', 'main')
     end

     it "should have title" do
       test_existing_attribute(@damsDS, 'title', 'UCSD Electronic Theses and Dissertations')
     end

     it "should have beginDate" do
       test_existing_attribute(@damsDS, 'beginDate', '2009-05-03')
     end

     it "should have language" do
       test_existing_attribute(@damsDS, 'language', 'http://library.ucsd.edu/ark:/20775/bd0410344f')
     end

     it "should have note" do
       test_existing_attribute(@damsDS, 'note', 'Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.')
     end

     it "should have noteDisplayLabel" do
       test_existing_attribute(@damsDS, 'noteDisplayLabel', 'Scope and contents')
     end

     it "should have noteType" do
       test_existing_attribute(@damsDS, 'noteType', 'scope_and_content')
     end

     it "should have relatedCollection" do
       test_existing_attribute(@damsDS, 'relatedCollection', 'http://library.ucsd.edu/ark:/20775/bb03030303')
     end

     it "should have provenanceCollection" do
       test_existing_attribute(@damsDS, 'hasProvenanceCollection', 'http://library.ucsd.edu/ark:/20775/bb24242424')
     end

     it "should have event" do
       test_existing_attribute(@damsDS, 'event', 'http://library.ucsd.edu/ark:/20775/bb28282828')
     end

  end
end
