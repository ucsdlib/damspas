class MadsConferenceName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsConferenceNameDatastream 
  delegate_to "damsMetadata", [:name, :sameAs, :elementList, :authority, :type]
  
end
