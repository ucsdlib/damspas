class MadsTopic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsTopicDatastream 
  delegate_to 'damsMetadata', [:name, :scheme, :elementList, :externalAuthority, :topicElement_attributes, :topicElement, :scheme_attributes]
end
