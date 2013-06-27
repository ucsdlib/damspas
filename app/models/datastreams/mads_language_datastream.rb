class MadsLanguageDatastream < MadsDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.code(:in => MADS)
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
    map.schemeNode( in: MADS, to: "isMemberOfMADSScheme", :class_name => 'MadsSchemeInternal')
    map.function(:in => DAMS, :class_name => 'DamsFunctionInternal')
  end
  def elementListValue
  	eList = elementList.first    
	eList[0] ?	eList[0].elementValue.first : []	
  end
  def elementListValue=(val)
    if val.class == Array
    	val = val.first
    end
    
  	if elementList[0] == nil
      elementList.build
    end
    #need to use eList.size to know where to insert/update the value
    eList = elementList.first
    languageElement = MadsDatastream::List::LanguageElement.new(elementList.first.graph)
    languageElement.elementValue = val
    if(eList[0].class == MadsDatastream::List::LanguageElement)
    	eList[0].elementValue = val
    else
    	eList[0] = languageElement	
    end
  end    
    
  def load_schemes(schemeNode)
	loadObjects schemeNode,MadsScheme
  end

  def insertFields (solr_doc, fieldName, objects)
    if objects != nil
      objects.each do |obj|
        Solrizer.insert_field(solr_doc, fieldName+"_name", obj.name)
        Solrizer.insert_field(solr_doc, fieldName+"_id", obj.pid)
        Solrizer.insert_field(solr_doc, "fulltext", obj.name)
      end
    end
  end 
  
 # helper method to load external classes
  def loadObjects (object,className)
    objects = []
    object.values.each do |name|
      name_uri = name.to_s
      name_pid = name_uri.gsub(/.*\//,'')
      if (name_pid != nil && name_pid != "" && !(name_pid.include? 'Internal'))
      	objects << className.find(name_pid)
      elsif name.name.first.nil? && name.pid != nil    
        objects << className.find(name.pid)      
      else 
      	objects << name
       end
    end
  	return objects
  end
         
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.Language]) if new?
    super
  end
  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'code', code.first)
	#insertFields solr_doc, 'scheme', load_schemes(schemeNode)
    #Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.to_s )    
    super
  end 
end
