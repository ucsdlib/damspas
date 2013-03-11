class DamsCartographic < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCartographicDatastream
  delegate_to "damsMetadata", [:point,:line,:polygon,:projection,:referenceSystem,:scale]
end
