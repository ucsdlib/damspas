require 'spec_helper'

describe DamsRoleDatastream do
   describe "with new datastream" do
      before do
    	@damsDS = DamsRoleDatastream.new(nil,'damsRoleMetadata')
      end
     it "should have code" do
       test_attribute_xpath(@damsDS, 'code', '//dams:Role/dams:code')
     end

    it "should have role" do
       test_attribute_xpath(@damsDS, 'value', '//dams:Role/rdf:value')
     end


    it "should have role valueURI" do
       test_attribute_xpath(@damsDS, 'valueURI', '//dams:Role/dams:valueURI/@rdf:resource')
     end

    it "should have role vocabularyId" do
       test_attribute_xpath(@damsDS, 'vocabularyId', '//dams:Role/dams:vocabulary/@rdf:resource')
     end

end

   describe "with existing datastream" do
     before do
       file = File.new(File.join(File.dirname(__FILE__),'..' ,'fixtures', "damsRole.xml"))
       @damsDS = DamsRoleDatastream.from_xml(file)
     end
     it "should have code" do
       test_existing_attribute(@damsDS, 'code', 'cre')
     end

     it "should have role" do
       test_existing_attribute(@damsDS, 'value', 'Creator')
     end

     it "should have valueURI" do
       test_existing_attribute(@damsDS, 'valueURI', 'http://id.loc.gov/vocabulary/relators/cre')
     end

     it "should have role vocabularyId" do
       test_existing_attribute(@damsDS, 'vocabularyId', 'http://library.ucsd.edu/ark:/20775/bb14141414')
     end

  end
end
