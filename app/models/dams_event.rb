class DamsEvent < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsEventDatastream 
  has_attributes :type, :eventDate, :outcome, :relationship, datastream: :damsMetadata,  multiple: true
end
