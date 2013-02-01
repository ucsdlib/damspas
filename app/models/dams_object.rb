class DamsObject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsObjectDatastream 
  delegate_to "damsMetadata", [:title, :typeOfResource, :subtitle, :date, :beginDate, :endDate, :subject, :component, :file, :relatedResource ]
end
