class MadsPersonalNameDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.sameAsNode(:in => OWL, :to => 'sameAs')
  end

  def sameAs=(val)
    @sameAs = RDF::Resource.new(val)
  end
  def sameAs
    if @sameAs != nil
      @sameAs
    else
      sameAsNode
    end
  end
  
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.PersonalName]) if new?
    graph.insert([rdf_subject, OWL.sameAs, @sameAs]) if new?
    super
  end

  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'name', name)
	Solrizer.insert_field(solr_doc, 'sameAs', sameAsNode.subject.to_s)
	
    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end

end

