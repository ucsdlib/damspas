class DamsStylePeriod < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsStylePeriodDatastream 
  delegate_to "damsMetadata", [:name, :authority, :valueURI, :elementList]
  
end
