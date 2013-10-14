class DamsProvenanceCollectionPartDatastream < DamsResourceDatastream
  include Dams::DamsProvenanceCollectionPart

  def to_solr (solr_doc = {})
          facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
          Solrizer.insert_field(solr_doc, 'type', 'Collection')   
          Solrizer.insert_field(solr_doc, 'type', 'Collection',facetable) 
          Solrizer.insert_field(solr_doc, 'type', 'ProvenanceCollectionPart')
          Solrizer.insert_field(solr_doc, 'resource_type', format_name(resource_type))
          Solrizer.insert_field(solr_doc, 'visibility', visibility)
          Solrizer.insert_field(solr_doc, 'object_type', format_name(resource_type),facetable)
          super
        end

end
