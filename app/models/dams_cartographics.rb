class DamsCartographics < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsCartographicsDatastream
  has_attributes :point,:line,:polygon,:projection,:referenceSystem,:scale, datastream: :damsMetadata, multiple: true
end
