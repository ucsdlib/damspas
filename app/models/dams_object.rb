class DamsObject < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  
  has_metadata :name => "damsMetadata", :type=> DamsObjectDatastream

  delegate_to 'damsMetadata', [:title, :arkUrl, :relatedTitle, :relatedTitleType, :relatedTitleLang, :beginDate, :endDate, :date, :languageId, :typeOfResource, :relatedResourceType, :relatedResourceDesc, :relatedResourceUri, :relationshipRole, :relationshipName, :assembledCollection], :unique=>"true" 
  


#   has_many :dams_languages, :property => :is_part_of

   belongs_to :dams_assembled_collection, :property => :is_member_of

end
