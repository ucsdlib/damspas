class DamsPerson < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsPersonDatastream 
  delegate :name, :to => "damsMetadata"
end
