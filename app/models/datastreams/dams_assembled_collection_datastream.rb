class DamsAssembledCollectionDatastream < DamsResourceDatastream
  include Dams::DamsAssembledCollection
  include Dams::ModelHelper
  
  def load_part
     if part_node.first.class.name.include? "DamsProvenanceCollectionPartInternal"
       part_node.first
     else
      part_uri = part_node.first.to_s
      part_pid = part_uri.gsub(/.*\//,'')
      if part_pid != nil && part_pid != ""
        DamsProvenanceCollectionPart.find(part_pid)
      end
    end
  end

  def load_provenanceCollection
     if provenanceCollection_node.first.class.name.include? "DamsProvenanceCollectionInternal"
       provenanceCollection_node.first
     else
      provenanceCollection_uri = provenanceCollection_node.first.to_s
      provenanceCollection_pid = provenanceCollection_uri.gsub(/.*\//,'')
      if provenanceCollection_pid != nil && provenanceCollection_pid != ""
        DamsProvenanceCollection.find(provenanceCollection_pid)
      end
    end
  end  
  
  def to_solr (solr_doc = {})
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    Solrizer.insert_field(solr_doc, 'type', 'Collection')
    Solrizer.insert_field(solr_doc, 'type', 'Collection',facetable)
    Solrizer.insert_field(solr_doc, 'type', 'AssembledCollection')
    Solrizer.insert_field(solr_doc, 'resource_type', format_name(resource_type))
    Solrizer.insert_field(solr_doc, 'object_type', format_name(resource_type),facetable)
    Solrizer.insert_field(solr_doc, 'visibility', visibility)
    
    part = load_part 
    if part != nil && part.class == DamsProvenanceCollectionPart
      Solrizer.insert_field(solr_doc, 'part_name', part.title.first.value)
      Solrizer.insert_field(solr_doc, 'part_id', part.pid)
      pj = { :id => part.pid, :name => part.title.first.value }
      Solrizer.insert_field(solr_doc, 'part_json', pj.to_json)
    end

    provenanceCollection=load_provenanceCollection
    if provenanceCollection != nil && provenanceCollection.class == DamsProvenanceCollection
      Solrizer.insert_field(solr_doc, 'provenanceCollection_name', provenanceCollection.title.first.value)
      Solrizer.insert_field(solr_doc, 'provenanceCollection_id', provenanceCollection.pid)
      prj = { :id => provenanceCollection.pid, :name => provenanceCollection.title.first.value }
      Solrizer.insert_field(solr_doc, 'provenanceCollection_json', prj.to_json)
    end
    super
  end  
end
