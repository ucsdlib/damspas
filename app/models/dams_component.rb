class DamsComponent < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsComponentDatastream 
  delegate_to "damsMetadata", [:title, :typeOfResource, :subtitle, :date, :beginDate, :endDate, :subject, :component, :file, :relatedResource, :title_node, :note_node, :odate, :titleType]
end
