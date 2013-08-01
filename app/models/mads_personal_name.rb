class MadsPersonalName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsPersonalNameDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :scheme, :externalAuthority, :fullNameValue, :familyNameValue, :givenNameValue, :dateNameValue, :termsOfAddressNameValue, :nameValue, :elementList_attributes, :scheme_attributes]
end
