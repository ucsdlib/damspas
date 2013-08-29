class DamsIconography < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsIconographyDatastream
  delegate_to 'damsMetadata', [:name, :scheme, :elementList, :externalAuthority, :iconographyElement_attributes, :iconographyElement, :scheme_attributes]
end
