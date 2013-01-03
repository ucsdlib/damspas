require 'spec_helper'

describe DamsVocabularyDatastream do
   describe "with new datastream" do
      before do
    	@damsDS = DamsVocabularyDatastream.new(nil,'damsVocabulary')
      end
     it "should have vocab desc" do
       test_attribute_xpath(@damsDS, 'vocabDesc', '//dams:Vocabulary/dams:description')
     end
   end

   describe "with existing datastream" do
     before do
       file = File.new(File.join(File.dirname(__FILE__),'..' ,'fixtures', "damsVocabularyModel.xml"))
       @damsDS = DamsVocabularyDatastream.from_xml(file)
     end

     it "should have vocab desc" do
       test_existing_attribute(@damsDS, 'vocabDesc', 'Language')
     end


  end
end
