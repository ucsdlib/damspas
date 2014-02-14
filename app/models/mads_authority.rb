class MadsAuthority < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsAuthorityDatastream
  has_attributes :code, :name, :description, :externalAuthority, :scheme, :scheme_attributes, datastream: :damsMetadata, multiple: true
  #def scheme
  #  damsMetadata.scheme
  #end
  #def scheme=(val)
  #  damsMetadata.scheme = RDF::Resource.new(Rails.configuration.id_namespace+val)
  #end
end
