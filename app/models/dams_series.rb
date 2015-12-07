class DamsSeries < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsSeriesDatastream
  has_attributes :name, :scheme, :elementList, :externalAuthority, :seriesElement_attributes, :seriesElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
end
