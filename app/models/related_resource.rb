  class RelatedResource < ActiveFedora::Rdf::Resource
    include ActiveFedora::Rdf::DefaultNodes
    rdf_type DAMS.RelatedResource
    map_predicates do |map|
      map.type(:in=> DAMS)
      map.description(:in=> DAMS)
      map.uri(:in=> DAMS)
    end
	def persisted?
	  rdf_subject.kind_of? RDF::URI
	end    
  end
