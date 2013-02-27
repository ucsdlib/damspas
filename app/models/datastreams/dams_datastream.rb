class DamsDatastream < ActiveFedora::RdfxmlRDFDatastream
    
 rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    super
  end
  
  def to_solr (solr_doc = {})
	n = 0
    Solrizer.insert_field(solr_doc, "note_#{n}_type", type)
    Solrizer.insert_field(solr_doc, "note_#{n}_display_label", displayLabel)
    Solrizer.insert_field(solr_doc, "note_#{n}_value", value)

	n = 0
    Solrizer.insert_field(solr_doc, "scope_content_note_#{n}_type", type)
    Solrizer.insert_field(solr_doc, "scope_content_note_#{n}_display_label", displayLabel)
    Solrizer.insert_field(solr_doc, "scope_content_note_#{n}_value", value)
          			
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

