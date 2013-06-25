class DamsCartographics < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCartographicsDatastream
  delegate_to "damsMetadata", [:point,:line,:polygon,:projection,:referenceSystem,:scale]
end
