class MadsAuthority < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => MadsAuthorityDatastream
  delegate_to 'damsMetadata', [ :code, :name, :description, :externalAuthority, :scheme ]
  def scheme
    damsMetadata.scheme
  end
  def scheme=(val)
    damsMetadata.scheme = RDF::Resource.new(Rails.configuration.id_namespace+val)
  end
end
