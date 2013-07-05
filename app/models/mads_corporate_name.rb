class MadsCorporateName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsCorporateNameDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :scheme, :externalAuthority, :fullNameValue, :familyNameValue, :givenNameValue, :dateNameValue, :nameLabel, :termOfAddressValue, :nameValue]
  
end
