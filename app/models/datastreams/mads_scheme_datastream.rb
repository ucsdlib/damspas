class MadsSchemeDatastream < ActiveFedora::RdfxmlRDFDatastream
  rdf_type MADS.MadsScheme
  map_predicates do |map|
    map.code( in: MADS )
    map.name( in: RDF::RDFS, to: "label" )
  end
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.MADSScheme]) if new?
    super
  end
  def to_solr(solr_doc ={})
    super( solr_doc )
    Solrizer.insert_field(solr_doc, "name", name.first )
    Solrizer.insert_field(solr_doc, "code", code.first )

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }
    # hack to make sure something is indexed for rights metadata
    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
      solr_doc[f] = 'dams-curator' unless solr_doc[f]
    }
    return solr_doc
  end
end
