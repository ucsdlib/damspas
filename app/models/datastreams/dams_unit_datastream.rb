class DamsUnitDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.name(:in => DAMS, :to => 'unitName')
    map.description(:in => DAMS, :to => 'unitDescription')
    map.uri(:in => DAMS, :to => 'unitURI')
    map.code(:in => DAMS, :to => 'code')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Unit]) if new?
    super
  end

  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'type', 'DamsUnit' )
    Solrizer.insert_field(solr_doc, 'unit_id', pid )
    Solrizer.insert_field(solr_doc, 'unit_code', code )
    Solrizer.insert_field(solr_doc, 'unit_name', name )
    Solrizer.insert_field(solr_doc, 'unit_uri', uri )
    Solrizer.insert_field(solr_doc, 'unit_description', description )

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end
end
