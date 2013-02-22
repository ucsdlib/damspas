class MadsPersonalNameDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.sameAsNode(:in => OWL, :to => 'sameAs')
    map.elementList(:in => MADS, :to => 'elementList', :class_name => 'ElementList')
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
 
  class ElementList
  	include ActiveFedora::RdfObject
  	rdf_type MADS.elementList
  	map_predicates do |map|   
    	map.fullNameElement(:in=> MADS, :to => 'FullNameElement', :class_name => 'FullNameElement')
    	map.dateNameElement(:in=> MADS, :to => 'DateNameElement', :class_name => 'DateNameElement')        
  	end
 
	class FullNameElement
	  	include ActiveFedora::RdfObject
	  	rdf_type MADS.FullNameElement
	  	map_predicates do |map|   
	    	map.elementValue(:in=> MADS, :to => 'elementValue')
	  	end	      
	 end       

	class DateNameElement
	  	include ActiveFedora::RdfObject
	  	rdf_type MADS.DateNameElement
	  	map_predicates do |map|   
	    	map.elementValue(:in=> MADS, :to => 'elementValue')
	  	end	      
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

