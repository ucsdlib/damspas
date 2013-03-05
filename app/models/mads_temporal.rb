class MadsTemporal < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsTemporalDatastream 
  delegate_to "damsMetadata", [:name, :sameAs, :elementList, :authority, :valueURI]
  
end
