class MadsPersonalName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsPersonalNameDatastream
  delegate_to 'damsMetadata', [:name, :scheme, :elementList, :externalAuthority, :scheme_attributes, :nameElement, :nameElement_attributes, :givenNameElement, :givenNameElement_attributes, :fullNameElement, :fullNameElement_attributes, :familyNameElement, :familyNameElement_attributes, :dateNameElement, :dateNameElement_attributes, :termsOfAddressNameElement, :termsOfAddressNameElement_attributes ]
end
