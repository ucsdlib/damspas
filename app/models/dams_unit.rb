class DamsUnit < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsUnitDatastream
  delegate_to "damsMetadata", [:name,:description,:uri,:code]
end
