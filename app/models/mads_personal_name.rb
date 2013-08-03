class MadsPersonalName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsPersonalNameDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :scheme, :externalAuthority, :fullNameValue, :fullNameElement_attributes, :fullNameElement, :familyNameValue, :familyNameElement_attributes, :familyNameElement, :givenNameValue, :givenNameElement_attributes, :givenNameElement, :dateNameValue, :dateNameElement_attributes, :dateNameElement, :termsOfAddressNameValue, :termsOfAddressNameElement_attributes, :termsOfAddressNameElement, :nameValue, :nameElement_attributes, :nameElement, :scheme_attributes]
end
