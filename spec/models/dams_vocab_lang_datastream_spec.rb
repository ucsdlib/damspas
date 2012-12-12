require 'spec_helper'

describe DamsVocabLangDatastream do
   describe "with new datastream" do
      before do
    	@damsDS = DamsVocabLangDatastream.new(nil,'damsVocabLang')
      end
     it "should have vocab desc" do
       test_attribute_xpath(@damsDS, 'vocabDesc', '//dams:Vocabulary/dams:description')
     end
   end

   describe "with existing datastream" do
     before do
       file = File.new(File.join(File.dirname(__FILE__),'..' ,'fixtures', "damsVocabLang.xml"))
       @damsDS = DamsVocabLangDatastream.from_xml(file)
     end

     it "should have vocab desc" do
       test_existing_attribute(@damsDS, 'vocabDesc', 'Language')
     end


  end
end
