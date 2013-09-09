class DamsStylePeriod < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsStylePeriodDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :elementList, :externalAuthority, :stylePeriodElement_attributes, :stylePeriodElement, :scheme_attributes]
  
end
