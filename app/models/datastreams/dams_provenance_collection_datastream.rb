class DamsProvenanceCollectionDatastream < DamsResourceDatastream
  include Dams::DamsProvenanceCollection

  def to_solr (solr_doc = {})
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    Solrizer.insert_field(solr_doc, 'type', 'Collection')
    Solrizer.insert_field(solr_doc, 'type', 'Collection',facetable)
    Solrizer.insert_field(solr_doc, 'type', 'ProvenanceCollection')
    Solrizer.insert_field(solr_doc, 'resource_type', format_name(resource_type))
    Solrizer.insert_field(solr_doc, 'object_type', format_name(resource_type),facetable)
    Solrizer.insert_field(solr_doc, 'visibility', visibility)

	insertCollectionFields solr_doc, 'part', part_node, DamsProvenanceCollectionPart
    super
  end           

end
