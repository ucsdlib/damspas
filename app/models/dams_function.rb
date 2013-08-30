class DamsFunction < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsFunctionDatastream 
 	delegate_to "damsMetadata", [:name, :scheme, :elementList, :externalAuthority, :functionElement_attributes, :functionElement, :scheme_attributes]
  
end