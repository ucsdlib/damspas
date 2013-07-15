class MadsComplexSubjectDatastream < MadsDatastream
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.schemeNode(:in => MADS, :to => 'isMemberOfMADSScheme')
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.componentList(:in => MADS, :to => 'componentList', :class_name=>'ComponentList')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  class ComponentList 
    include ActiveFedora::RdfList    

     class Topic
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.Topic
     	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
        	#map.elementList(:in => MADS, :to => 'elementList', :class_name=>'ElementList')
      	end     
	    #class ElementList 
	    #	include ActiveFedora::RdfList	   
	  	#end
	 end     
     class GenreForm
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.GenreForm
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end    
     class Iconography
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type DAMS.Iconography
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end 	  	 
     class ScientificName
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type DAMS.ScientificName
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end    	 
     class Technique
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type DAMS.Technique
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end 	 
	 class BuiltWorkPlace
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type DAMS.BuiltWorkPlace
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end    	 
     class PersonalName
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.PersonalName
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end 	 
	 class Geographic
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.Geographic
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end    	 
     class Temporal
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.Temporal
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end 		  
	 class CulturalContext
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type DAMS.CulturalContext
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end    
     class StylePeriod
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type DAMS.StylePeriod
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end 	 
	 class ConferenceName
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.ConferenceName
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end    
     class Function
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type DAMS.Function
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end 
	 class CorporateName
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.CorporateName
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end    
     class Occupation
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.Occupation
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end 
     class FamilyName
      	include ActiveFedora::RdfObject
        include ActiveFedora::Rdf::DefaultNodes
      	rdf_type MADS.FamilyName
      	map_predicates do |map|   
        	map.name(:in => MADS, :to => 'authoritativeLabel')
      	end    
	 end 	 	    	 
  end
  
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.ComplexSubject]) if new?
    super
  end
#  def method_missing(method_name)
#  	puts ("no method")
#  end
  def loadExternalObject (uri)
  	md = /\/(\w*)$/.match(uri)
  	if (!uri.include? 'Internal')
 		obj = MadsTopic.find(md[1])
 	end
 	if (!obj.nil?)
 		hasModel = obj.relationships(:has_model).to_s
 	end
    if (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsGenreForm'))
    	obj = MadsGenreForm.find(md[1]) 
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'DamsIconography'))
    	obj = DamsIconography.find(md[1])     
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'DamsScientificName'))
    	obj = DamsScientificName.find(md[1])   
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'DamsTechnique'))
    	obj = DamsTechnique.find(md[1])     	    
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'DamsBuiltWorkPlace'))
    	obj = DamsBuiltWorkPlace.find(md[1])   
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsPersonalName'))
    	obj = MadsPersonalName.find(md[1])   
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsGeographic'))
    	obj = MadsGeographic.find(md[1])   
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsTemporal'))
    	obj = MadsTemporal.find(md[1])      
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'DamsCulturalContext'))
    	obj = DamsCulturalContext.find(md[1])     	    
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'DamsStylePeriod'))
    	obj = DamsStylePeriod.find(md[1])   
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsConferenceName'))
    	obj = MadsConferenceName.find(md[1])   
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'DamsFunction'))
    	obj = DamsFunction.find(md[1])   
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsCorporateName'))
    	obj = MadsCorporateName.find(md[1])  
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsOccupation'))
    	obj = MadsOccupation.find(md[1])     	    
    elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'MadsFamilyName'))
    	obj = MadsFamilyName.find(md[1])        	    	 	    	    	    			
    end
    obj
  end
  
  def insertFields (solr_doc,elementName,object,number)
  	Solrizer.insert_field(solr_doc, "complexSubject_0_#{number}_#{elementName}", object.name.first)	
	#list = object.elementList.first			
	#if list != nil
	#    j = 0
	#	while j < list.size  do
	#		Solrizer.insert_field(solr_doc, "complexSubject_#{number}_#{j}_#{elementName}", list[j].elementValue.first)						
	#		j +=1
	#	end
	#end		
  end
   
  def to_solr (solr_doc = {})
	cList = componentList.first
	i = 0
	if cList != nil
		while i < cList.size  do
		  if (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Topic || cList[i].class == MadsTopicInternal)
		    insertFields solr_doc,"topic",cList[i],i		
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::GenreForm || cList[i].class == MadsGenreFormInternal)
		    insertFields solr_doc,"genreForm",cList[i],i
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Iconography || cList[i].class == DamsIconographyInternal)
		    insertFields solr_doc,"iconography",cList[i],i		
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::ScientificName || cList[i].class == DamsScientificNameInternal)
		    insertFields solr_doc,"scientificName",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Technique || cList[i].class == DamsTechniqueInternal)
		    insertFields solr_doc,"technique",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::BuiltWorkPlace || cList[i].class == DamsBuiltWorkPlaceInternal)
		    insertFields solr_doc,"builtWorkPlace",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::PersonalName)
		    insertFields solr_doc,"personalName",cList[i],i		
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Geographic || cList[i].class == MadsGeographicInternal)
		    insertFields solr_doc,"geographic",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Temporal || cList[i].class == MadsTemporalInternal)
		    insertFields solr_doc,"temporal",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::CulturalContext || cList[i].class == DamsCulturalContextInternal)
		    insertFields solr_doc,"culturalContext",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::StylePeriod || cList[i].class == DamsStylePeriodInternal)
		    insertFields solr_doc,"stylePeriod",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::ConferenceName)
		    insertFields solr_doc,"conferenceName",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Function || cList[i].class == DamsFunctionInternal)
		    insertFields solr_doc,"function",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::CorporateName)
		    insertFields solr_doc,"corporateName",cList[i],i	
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::Occupation || cList[i].class == MadsOccupationInternal)
		    insertFields solr_doc,"occupation",cList[i],i		
		  elsif (cList[i].class == MadsComplexSubjectDatastream::ComponentList::FamilyName)
		    insertFields solr_doc,"familyName",cList[i],i				    	    		    	    		    		    		        
		  else
		    obj = loadExternalObject(cList[i].to_s)
		    if (!obj.nil? && obj.class == MadsGenreForm)
		    	insertFields solr_doc,"genreForm",obj,i
		    elsif (!obj.nil? && obj.class == MadsTopic)
		    	insertFields solr_doc,"topic",obj,i		
		    elsif (!obj.nil? && obj.class == DamsIconography)
		    	insertFields solr_doc,"iconography",obj,i	
		    elsif (!obj.nil? && obj.class == DamsScientificName)
		    	insertFields solr_doc,"scientificName",obj,i  
		    elsif (!obj.nil? && obj.class == DamsTechnique)
		    	insertFields solr_doc,"technique",obj,i     	    
		    elsif (!obj.nil? && obj.class == DamsBuiltWorkPlace)
		    	insertFields solr_doc,"builtWorkPlace",obj,i  
		    elsif (!obj.nil? && obj.class == MadsPersonalName)
		    	insertFields solr_doc,"personalName",obj,i   
		    elsif (!obj.nil? && obj.class == MadsGeographic)
		    	insertFields solr_doc,"geographic",obj,i
		    elsif (!obj.nil? && obj.class == MadsTemporal)
		    	insertFields solr_doc,"temporal",obj,i     
		    elsif (!obj.nil? && obj.class == DamsCulturalContext)
		    	insertFields solr_doc,"culturalContext",obj,i   	    
		    elsif (!obj.nil? && obj.class == DamsStylePeriod)
		    	insertFields solr_doc,"stylePeriod",obj,i 
		    elsif (!obj.nil? && obj.class == MadsConferenceName)
		    	insertFields solr_doc,"conferenceName",obj,i   
		    elsif (!obj.nil? && obj.class == DamsFunction)
		    	insertFields solr_doc,"function",obj,i   
		    elsif (!obj.nil? && obj.class == MadsCorporateName)
		    	insertFields solr_doc,"corporateName",obj,i  
		    elsif (!obj.nil? && obj.class == MadsOccupation)
		    	insertFields solr_doc,"occupation",obj,i    	    
		    elsif (!obj.nil? && obj.class == MadsFamilyName)
		    	insertFields solr_doc,"familyName",obj,i		    		    				    			
		    end									
		  end		  
		  i +=1
		end   
	end 
			
    super
    return solr_doc
  end  
end
