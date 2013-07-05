class MadsConferenceName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsConferenceNameDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :scheme, :type, :externalAuthority, :fullNameValue, :familyNameValue, :givenNameValue, :dateNameValue, :nameLabel, :termOfAddressValue, :nameValue]
  
end
