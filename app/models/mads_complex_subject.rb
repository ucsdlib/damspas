class MadsComplexSubject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsComplexSubjectDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :authority, :valueURI]
end
