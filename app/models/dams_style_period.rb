class DamsStylePeriod < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsStylePeriodDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :stylePeriodElement_attributes, :stylePeriodElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end
