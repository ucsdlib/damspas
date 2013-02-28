class DamsDatastream < ActiveFedora::RdfxmlRDFDatastream
    
 rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    super
  end
  
  def to_solr (solr_doc = {})
	n = 0
  #  Solrizer.insert_field(solr_doc, "note_#{n}_type", type)
  #  Solrizer.insert_field(solr_doc, "note_#{n}_display_label", displayLabel)
  #  Solrizer.insert_field(solr_doc, "note_#{n}_value", value)

 #	n = 0
 #   Solrizer.insert_field(solr_doc, "scope_content_note_#{n}_type", type)
 #   Solrizer.insert_field(solr_doc, "scope_content_note_#{n}_display_label", displayLabel)
 #   Solrizer.insert_field(solr_doc, "scope_content_note_#{n}_value", value)
  
  	list = elementList.first
	i = 0
	if list != nil
		while i < list.size  do
		  if (list[i].class == DamsDatastream::ListNote::ScopeContentNote)
			Solrizer.insert_field(solr_doc, 'scope_content_note_#{i}_value', list[i].value.first)
	 	  elsif (list[i].class == DamsDatastream::ListNote::Note)
			Solrizer.insert_field(solr_doc, 'note_#{i}_value', list[i].value.first)		
																
		  end		  
		  i +=1
		end   
	end 
          			
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

