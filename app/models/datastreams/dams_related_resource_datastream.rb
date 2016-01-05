class DamsRelatedResourceDatastream < ActiveFedora::RdfxmlRDFDatastream

  map_predicates do |map|
    map.type(:in=> DAMS)
    map.description(:in=> DAMS)
    map.uri(:in=> DAMS)
  end

  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.RelatedResource]) if new?
    super
  end

  def to_solr (solr_doc={})
    Solrizer.insert_field(solr_doc, "type", type )
    Solrizer.insert_field(solr_doc, "relatedResourceURI", uri )
    Solrizer.insert_field(solr_doc, "relatedResourceDescription", description )

      # hack to make sure something is indexed for rights metadata
    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
      solr_doc[f] = 'dams-curator' unless solr_doc[f]
    }
    solr_base solr_doc
  end
end
