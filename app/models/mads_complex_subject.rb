class MadsComplexSubject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsComplexSubjectDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :scheme, :componentList, :externalAuthority]
end
