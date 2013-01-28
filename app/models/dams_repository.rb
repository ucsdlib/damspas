class DamsRepository < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsRepositoryDatastream
  delegate_to "damsMetadata", [:name,:description,:uri]
end
