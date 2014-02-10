class DamsFunction < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsFunctionDatastream 
  has_attributes :name, :scheme, :elementList, :externalAuthority, :functionElement_attributes, :functionElement, :scheme_attributes, datastream: :damsMetadata, multiple: true
  
end
