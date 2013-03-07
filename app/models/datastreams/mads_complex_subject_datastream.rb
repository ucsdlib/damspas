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
	  	end
	 end     
     class GenreForm
      	include ActiveFedora::RdfObject
      	rdf_type MADS.GenreForm
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
        	map.elementList(:in => MADS, :to => 'elementList', :class_name=>'ElementList')
      	end    
	    class ElementList 
	    	include ActiveFedora::RdfList	   
	  	end
	 end       	 
  end
  
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.ComplexSubject]) if new?
    super
  end
  
  def loadExternalObject (uri)
  	md = /\/(\w*)$/.match(uri)
 	obj = MadsTopic.find(md[1])
 	hasModel = obj.relationships(:has_model).to_s
    if (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsGenreForm'))
    	obj = MadsGenreForm.find(md[1]) 
    end
    obj
  end
  def to_solr (solr_doc = {})
	cList = componentList.first
	i = 0
	if cList != nil
		while i < cList.size  do
		  if (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Topic)
			Solrizer.insert_field(solr_doc, "complexSubject_#{i}_topic", cList[i].name.first)	
			topicList = cList[i].elementList.first			
			if topicList != nil
			    j = 0
				while j < topicList.size  do
					Solrizer.insert_field(solr_doc, "complexSubject_#{i}_#{j}_topic", topicList[j].elementValue.first)						
					j +=1
				end
			end		
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::GenreForm)
				Solrizer.insert_field(solr_doc, "complexSubject_#{i}_genreForm", cList[i].name.first)	
				genreFormList = cList[i].elementList.first			
				if genreFormList != nil
				    j = 0
					while j < genreFormList.size  do
						Solrizer.insert_field(solr_doc, "complexSubject_#{i}_#{j}_genreForm", genreFormList[j].elementValue.first)						
						j +=1
					end
				end	
		  else
		    obj = loadExternalObject(cList[i].to_s)
		    if (!obj.nil? && obj.class == MadsGenreForm)
				Solrizer.insert_field(solr_doc, "complexSubject_#{i}_genreForm", obj.name.first)	
				list = obj.elementList.first			
				if list != nil
				    j = 0
					while j < list.size  do
						Solrizer.insert_field(solr_doc, "complexSubject_#{i}_#{j}_genreForm", list[j].elementValue.first)						
						j +=1
					end
				end	
		    elsif (!obj.nil? && obj.class == MadsTopic)
				Solrizer.insert_field(solr_doc, "complexSubject_#{i}_topic", obj.name.first)	
				list = obj.elementList.first			
				if list != nil
				    j = 0
					while j < list.size  do
						Solrizer.insert_field(solr_doc, "complexSubject_#{i}_#{j}_topic", list[j].elementValue.first)						
						j +=1
					end
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
