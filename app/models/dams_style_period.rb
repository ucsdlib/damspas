class DamsStylePeriod < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsStylePeriodDatastream 
  delegate_to "damsMetadata", [:name, :scheme, :externalAuthority, :elementList, :elementValue]
  
end
