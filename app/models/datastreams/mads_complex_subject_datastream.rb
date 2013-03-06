class MadsComplexSubjectDatastream < MadsDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.sameAsNode(:in => OWL, :to => 'sameAs')
    map.authority(:in => DAMS, :to => 'authority')
    map.valURI(:in => DAMS, :to => 'valueURI')
    map.componentList(:in => MADS, :to => 'componentList', :class_name=>'ComponentList')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  class ComponentList 
    include ActiveFedora::RdfList     
    class Topic
      include ActiveFedora::RdfObject
      rdf_type MADS.Topic
      map_predicates do |map|   
        map.name(:in => MADS, :to => 'authoritativeLabel')
        map.elementList(:in => MADS, :to => 'elementList', :class_name=>'ElementList')
      end
     
	    class ElementList 
	    	include ActiveFedora::RdfList	   
	    #	class TopicElement
	    #  		include ActiveFedora::RdfObject
	    #  		rdf_type MADS.TopicElement
	    #  		map_predicates do |map|   
	    #    		map.elementValue(:in=> MADS)
	    #  		end
	    #	end     
	  	end
	 end       
  end
  
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.ComplexSubject]) if new?
    super
  end
  
  def to_solr (solr_doc = {})
	cList = componentList.first
	i = 0
	if cList != nil
		while i < cList.size  do
		  if (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Topic)
			Solrizer.insert_field(solr_doc, "topic_#{i}", cList[i].name.first)	
			topicList = cList[i].elementList.first			
			if topicList != nil
			    j = 0
				while j < topicList.size  do
					if (topicList[j].class.name.include? 'TopicElement')
						Solrizer.insert_field(solr_doc, "topic_element_#{i}_#{j}", topicList[j].elementValue.first)	
					end
					j +=1
				end
			end														
		  end		  
		  i +=1
		end   
	end 
			
    super
    return solr_doc
  end  
end
