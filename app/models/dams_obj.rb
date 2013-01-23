class DamsObj < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsRdfDatastream 
  delegate_to "damsMetadata", [:title,:date, :subject]
end
