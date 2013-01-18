require 'spec_helper'

describe DamsLanguage do
  
  before  do
    DamsLanguage.find_each {|z| z.delete}
    @damsLang = DamsLanguage.new
  end
  
  it "should have the specified datastreams" do
    @damsLang.datastreams.keys.should include("damsMetadata")
    @damsLang.damsMetadata.should be_kind_of DamsLanguageDatastream
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

  it "should have a language valueURI" do
    @damsLang.language = "http://id.loc.gov/vocabulary/iso639-1/fr"
    @damsLang.language == "http://id.loc.gov/vocabulary/iso639-1/fr"
  end

end

