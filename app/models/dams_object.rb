class DamsObject < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsObjectDatastream 
  delegate_to "damsMetadata", [:title,:date, :subject]
end
