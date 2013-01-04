class DamsAssembledCollection < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsCollectionMetadata", :type=> DamsAssembledCollectionDatastream
 
  delegate_to 'damsCollectionMetadata', [:titleType, :title, :beginDate, :language, :note, :noteDisplayLabel, :noteType, :relatedCollection, :hasProvenanceCollection, :event ], :unique=>"true"

  has_many :dams_objects, :property => :is_member_of
end
