require 'spec_helper'

describe DamsLanguage do
  
  before  do
    DamsLanguage.find_each {|z| z.delete}
    @damsLang = DamsLanguage.new
  end
  
  it "should have the specified datastreams" do
    @damsLang.datastreams.keys.should include("damsLanguage")
    @damsLang.damsLanguage.should be_kind_of DamsLanguageDatastream
    @damsLang.datastreams.keys.should include("rightsMetadata")
    @damsLang.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
 end
  
  it "should have a language code" do
    @damsLang.code = "fr"
    @damsLang.code == "fr"
  end

  it "should have a language" do
    @damsLang.language = "french"
    @damsLang.language == "french"
  end

end

