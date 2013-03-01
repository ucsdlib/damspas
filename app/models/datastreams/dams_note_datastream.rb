class DamsNoteDatastream < DamsDatastream
  map_predicates do |map|    
    map.value(:in=> RDF)
    map.displayLabel(:in=>DAMS)
    map.type(:in=>DAMS)
  end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Note]) if new?
    super
  end
  def to_solr (solr_doc = {})           
    Solrizer.insert_field(solr_doc, 'note_value', value)
	Solrizer.insert_field(solr_doc, 'note_displayLabel', displayLabel)
	Solrizer.insert_field(solr_doc, 'note_type', type) 			
	super
    return solr_doc
  end  
end
