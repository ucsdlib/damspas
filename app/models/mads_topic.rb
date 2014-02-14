class MadsTopic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsTopicDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :topicElement_attributes, :topicElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
end
