class MadsTopic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsTopicDatastream 
  delegate_to 'damsMetadata', [:name, :elementList, :scheme, :externalAuthority]
end
