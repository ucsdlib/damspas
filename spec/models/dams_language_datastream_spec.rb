require 'spec_helper'

describe DamsLanguageDatastream do
   describe "with new datastream" do
      before do
    	@damsDS = DamsLanguageDatastream.new(nil,'damsLanguageMetadata')
      end
     it "should have code" do
       test_attribute_xpath(@damsDS, 'code', '//dams:Language/dams:code')
     end

    it "should have language" do
       test_attribute_xpath(@damsDS, 'language', '//dams:Language/rdf:value')
     end


   end

   describe "with existing datastream" do
     before do
       file = File.new(File.join(File.dirname(__FILE__),'..' ,'fixtures', "damsLanguageModel.xml"))
       @damsDS = DamsLanguageDatastream.from_xml(file)
     end
     it "should have code" do
       test_existing_attribute(@damsDS, 'code', 'fr')
     end

     it "should have language" do
       test_existing_attribute(@damsDS, 'language', 'French')
     end


  end
end
