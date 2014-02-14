class DamsComponent < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsComponentDatastream 
  has_attributes :title, :titleValue, :subtitle, :typeOfResource, :date, :beginDate, :endDate, :subject, :component, :file, :relatedResource, datastream: :damsMetadata,  multiple: true
end
