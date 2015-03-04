class DamsProvenanceCollectionPartDatastream < DamsResourceDatastream
  include Dams::ProvenanceCollectionPart

  def to_solr (solr_doc = {})
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    Solrizer.insert_field(solr_doc, 'type', 'Collection')   
    Solrizer.insert_field(solr_doc, 'type', 'Collection',facetable) 
    Solrizer.insert_field(solr_doc, 'type', 'ProvenanceCollectionPart')
    Solrizer.insert_field(solr_doc, 'resource_type', format_name(resource_type))
    Solrizer.insert_field(solr_doc, 'visibility', visibility)
    Solrizer.insert_field(solr_doc, 'object_type', format_name(resource_type),facetable)
    insertCollectionFields solr_doc, 'provenanceCollection', provenanceCollection_node, DamsProvenanceCollection
    insertUnitFields solr_doc, unit
    super
  end

end
