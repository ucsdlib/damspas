require 'spec_helper'

describe DamsObjectDatastream do
   describe "with new datastream" do
      before do
    	@damsDS = DamsObjectDatastream.new(nil,'titleMetadata')
      end
     it "should have title" do
       test_attribute_xpath(@damsDS, 'title', '//dams:Object/dams:title/rdf:value')
     end

    it "should have ark url" do
       test_attribute_xpath(@damsDS, 'arkUrl', '//dams:Object/@rdf:about')
     end

     it "should have relatedTitle" do
       test_attribute_xpath(@damsDS, 'relatedTitle', '//dams:Object/dams:title/dams:relatedTitle/rdf:value')
     end

     it "should have relatedTitleType" do
       test_attribute_xpath(@damsDS, 'relatedTitleType', '//dams:Object/dams:title/dams:relatedTitle/dams:type')
     end

     it "should have relatedTitleLanguage" do
       test_attribute_xpath(@damsDS, 'relatedTitleLang', '//dams:Object/dams:title/dams:relatedTitle/rdf:value/@xml:lang')
     end

     it "should have begin date" do
       test_attribute_xpath(@damsDS, 'beginDate', '//dams:Object/dams:date/dams:beginDate')
     end

     it "should have end date" do
       test_attribute_xpath(@damsDS, 'endDate', '//dams:Object/dams:date/dams:endDate')
     end

     it "should have date" do
       test_attribute_xpath(@damsDS, 'date', '//dams:Object/dams:date/rdf:value')
     end

   end

   describe "with existing datastream" do
     before do
       file = File.new(File.join(File.dirname(__FILE__),'..' ,'fixtures', "damsObjectModel.xml"))
       @damsDS = DamsObjectDatastream.from_xml(file)
     end
     it "should have title" do
       test_existing_attribute(@damsDS, 'title', 'example title')
     end

     it "should have ark url" do
       test_existing_attribute(@damsDS, 'arkUrl', 'http://library.ucsd.edu/ark:/20775/')
     end

     #it "should have title" do
     #  @damsDS.title = ["example title"]
     # end
    it "should have relatedTitle" do
        test_existing_attribute(@damsDS, 'relatedTitle', 'example translated relatedTitle')
     end   

    it "should have relatedTitleLanguage" do
       test_existing_attribute(@damsDS, 'relatedTitleLang', 'fr')
    end

    it "should have relatedTitleType" do
       test_existing_attribute(@damsDS, 'relatedTitleType', 'translated') 
    end

    it "should have begin Date" do
       test_existing_attribute(@damsDS, 'beginDate', '2012-11-27')
    end

    it "should have end Date" do
       test_existing_attribute(@damsDS, 'endDate', '2012-11-30')
    end

    it "should have Date" do
       test_existing_attribute(@damsDS, 'date', '2012-11-29')
    end

  end
end
