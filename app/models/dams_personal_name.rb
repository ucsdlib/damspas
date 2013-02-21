class DamsPersonalName < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsPersonalNameDatastream 
  delegate :name, :to => "damsMetadata"
end
