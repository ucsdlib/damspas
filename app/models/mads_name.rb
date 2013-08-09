class MadsName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsNameDatastream 
  delegate_to "damsMetadata", [:name, :elementList, :externalAuthority,
    :scheme, :scheme_attributes,
    :nameElement, :nameElement_attributes, :nameValue,
    :givenNameElement, :givenNameElement_attributes, :givenNameValue,
    :fullNameElement, :fullNameElement_attributes, :fullNameValue,
    :familyNameElement, :familyNameElement_attributes, :familyNameValue,
    :dateNameElement, :dateNameElement_attributes, :dateNameValue,
    :termsOfAddressNameElement, :termsOfAddressNameElement_attributes, :termsOfAddressNameValue]
end
