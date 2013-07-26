class MadsTopic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsTopicDatastream 
  delegate_to 'damsMetadata', [:label, :elementList, :scheme, :externalAuthority]
end
