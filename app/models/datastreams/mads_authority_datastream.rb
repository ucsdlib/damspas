class MadsAuthorityDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.code( in: MADS )
    map.name( in: MADS, to: "authoritativeLabel" )
    map.description( in: MADS, to: "definitionNote" )
    map.scheme( in: MADS, to: "isMemberOfMADSScheme", class_name: "MadsScheme" )
    map.external( in: MADS, to: "hasExactExternalAuthority" )
  end
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.MadsAuthority]) if new?
    super
  end
  def to_solr(solr_doc ={})
    super( solr_doc )
    Solrizer.insert_field(solr_doc, "name", name.first )
    Solrizer.insert_field(solr_doc, "code", code.first )
    Solrizer.insert_field(solr_doc, "description", code.first )
    Solrizer.insert_field(solr_doc, "scheme_id", scheme.pid )
    Solrizer.insert_field(solr_doc, "scheme_name", scheme.name )
    Solrizer.insert_field(solr_doc, "external", external )

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }

    return solr_doc
  end
end
