require 'spec_helper'

describe DamsVocab do
  
  before  do
    DamsVocab.find_each {|z| z.delete}
    @damsVocab = DamsVocab.new
  end
  
  it "should have the specified datastreams" do
    @damsVocab.datastreams.keys.should include("damsMetadata")
    @damsVocab.damsMetadata.should be_kind_of DamsVocabularyDatastream
    @damsVocab.datastreams.keys.should include("rightsMetadata")
    @damsVocab.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
 end
  
  it "should have a vocabulary description" do
    @damsVocab.vocabDesc = "Language"
    @damsVocab.vocabDesc == "Language"
  end


end

