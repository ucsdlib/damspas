module DamsHelper
  def subtitle
    title[0] ? title[0].subtitle : []
  end
  def subtitle=(val)
    if val.class == Array
    	val = val.first
    end
    if(!val.nil? && val.length > 0)
    	title.build if title[0] == nil
    	title[0].subtitle = val
    end
  end

  def titleValue
    title[0] ? title[0].value : []
  end
  def titleValue=(val)
    if val.class == Array
    	val = val.first
    end
    if(!val.nil? && val.length > 0)
    	title.build if title[0] == nil
    	title[0].value = val
    end
  end
  
  def titleType
    title[0] ? title[0].type : []
  end
  def titleType=(val)
    if val.class == Array
    	val = val.first
    end
    if(!val.nil? && val.length > 0)
    	title.build if title[0] == nil
    	title[0].type = val
    end
  end
    
  def subjectValue
    subject[0] ? subject[0].name : []
  end
  def subjectValue=(val)
    i = 0
	val.each do |v| 
		if(!v.nil? && v.length > 0)
		    subject.build if subject[i] == nil
		    subject[i].name = v
		end
		i+=1
	end
  end

  def subjectType
    @subType
  end
  def subjectType=(val)
    #@subType = val
    @subType = Array.new
    i = 0
	val.each do |v| 
	    if(!v.nil? && v.length > 0)
	    	@subType << v 	
	    end
		i+=1
	end
  end
   
  def subjectTypeValue
    #topic[0] ? topic[0].name : []
    if(!@subType.nil? && (@subType.include? 'Topic'))
	    topic[0] ? topic[0].name : []
	elsif(!@subType.nil? && (@subType.include? 'BuiltWorkPlace'))
	    builtWorkPlace[0] ? builtWorkPlace[0].name : []		
	elsif(!@subType.nil? && (@subType.include? 'CulturalContext'))
	    culturalContext[0] ? culturalContext[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'Function'))
	    function[0] ? function[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'GenreForm'))
	    genreForm[0] ? genreForm[0].name : []		
	elsif(!@subType.nil? && (@subType.include? 'Geographic'))
	    geographic[0] ? geographic[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'Iconography'))
	    iconography[0] ? iconography[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'ScientificName'))
	    scientificName[0] ? scientificName[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'StylePeriod'))
	    stylePeriod[0] ? stylePeriod[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'Technique'))
	    technique[0] ? technique[0].name : []	
	elsif(!@subType.nil? && (@subType.include? 'Temporal'))
	    temporal[0] ? temporal[0].name : []	    	    	    	        	    	    	    
    end
  end
  def subjectTypeValue=(val)
    i = 0
    topicIndex = 0
    workplaceIndex = 0
    culturalContextIndex = 0
    functionIndex = 0
    genreFormIndex = 0
    geographicIndex = 0
    iconographyIndex = 0
    scientificNameIndex = 0
    stylePeriodIndex = 0
    techniqueIndex = 0
    temporalIndex = 0
	val.each do |v| 
		if(!v.nil? && v.length > 0)
			if(!@subType[i].nil? && (@subType[i].include? 'Topic'))
			    topic.build if topic[topicIndex] == nil
			    topic[topicIndex].name = v
			    topicIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'BuiltWorkPlace'))
			    builtWorkPlace.build if builtWorkPlace[workplaceIndex] == nil
			    builtWorkPlace[workplaceIndex].name = v	
			    workplaceIndex+=1	
			elsif(!@subType[i].nil? && (@subType[i].include? 'CulturalContext'))
			    culturalContext.build if culturalContext[culturalContextIndex] == nil
			    culturalContext[culturalContextIndex].name = v
			    culturalContextIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'Function'))
			    function.build if function[functionIndex] == nil
			    function[functionIndex].name = v	
			    functionIndex+=1	
			elsif(!@subType[i].nil? && (@subType[i].include? 'GenreForm'))
			    genreForm.build if genreForm[genreFormIndex] == nil
			    genreForm[genreFormIndex].name = v
			    genreFormIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'Geographic'))
			    geographic.build if geographic[geographicIndex] == nil
			    geographic[geographicIndex].name = v	
			    geographicIndex+=1	
			elsif(!@subType[i].nil? && (@subType[i].include? 'Iconography'))
			    iconography.build if iconography[iconographyIndex] == nil
			    iconography[iconographyIndex].name = v
			    iconographyIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'ScientificName'))
			    scientificName.build if scientificName[scientificNameIndex] == nil
			    scientificName[scientificNameIndex].name = v	
			    scientificNameIndex+=1	
			elsif(!@subType[i].nil? && (@subType[i].include? 'Technique'))
			    technique.build if technique[techniqueIndex] == nil
			    technique[techniqueIndex].name = v
			    techniqueIndex+=1
			elsif(!@subType[i].nil? && (@subType[i].include? 'Temporal'))
			    temporal.build if temporal[temporalIndex] == nil
			    temporal[temporalIndex].name = v	
			    temporalIndex+=1				    			    			    			    	    
		    end
		end
		i+=1
	end
  end
    
  def subjectURI=(val)
    i = 0
    @array_subject = Array.new
	val.each do |v| 
	    if(!v.nil? && v.length > 0)
	    	@subURI = RDF::Resource.new("http://library.ucsd.edu/ark:/20775/#{v}")  
	    	@array_subject << @subURI  	
	    end
		i+=1
	end
  end
  def subjectURI
    if @subURI != nil
      @subURI
    else
      subURI.first
    end
  end 
  def unitURI=(val)
    if val.class == Array
    	val = val.first
    end
    if(!val.nil? && val.length > 0)
    	@unitURI = RDF::Resource.new("http://library.ucsd.edu/ark:/20775/#{val}")
    end
  end
  def unitURI
    if @unitURI != nil
      @unitURI
    else
      unitURI.first
    end
  end     
  ## Date ######################################################################
  def beginDate
    date[0] ? date[0].beginDate : []
  end
  def beginDate=(val)
    if val.class == Array
    	val = val.first
    end
  	if(!val.nil? && val.length > 0)
	    date.build if date[0] == nil
	    date[0].beginDate = val
    end
  end

  def endDate
    date[0] ? date[0].endDate : []
  end
  def endDate=(val)
    if val.class == Array
    	val = val.first
    end  
    if(!val.nil? && val.length > 0)
    	date.build if date[0] == nil
    	date[0].endDate = val
    end
  end
  def dateValue
    date[0] ? date[0].value : []
  end
  def dateValue=(val)
    if val.class == Array
    	val = val.first
    end  
    if(!val.nil? && val.length > 0)
    	date.build if date[0] == nil
    	date[0].value = val
    end
  end

  ## Note ######################################################################


  def scopeContentNoteType
    scopeContentNote.first ? scopeContentNote.first.type : []
  end
  def scopeContentNoteType=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.type = val
  end
  def scopeContentNoteDisplayLabel
    scopeContentNote.first ? scopeContentNote.first.displayLabel : []
  end
  def scopeContentNoteDisplayLabel=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.displayLabel = val
  end
  def scopeContentNoteValue
    scopeContentNote.first ? scopeContentNote.first.value : []
  end
  def scopeContentNoteValue=(val)
    if scopeContentNote == nil
      scopeContentNote = []
    end
    scopeContentNote.first.value = val
  end   
  
  def permissionBeginDate
    permission_node[0] ? permission_node[0].beginDate : []
  end
  def permissionBeginDate=(val)
    if permission_node[0] == nil
      permission_node.build
    end
    permission_node[0].beginDate = val
  end
  def permissionEndDate
    permission_node[0] ? permission_node[0].endDate : []
  end
  def permissionEndDate=(val)
    if permission_node[0] == nil
      permission_node.build
    end
    permission_node[0].endDate = val
  end
  def permissionType
    permission_node[0] ? permission_node[0].type : []
  end
  def permissionType=(val)
    if permission_node[0] == nil
      permission_node.build
    end
    permission_node[0].type = val
  end

  def restrictionBeginDate
    restriction_node[0] ? restriction_node[0].beginDate : []
  end
  def restrictionBeginDate=(val)
    if restriction_node[0] == nil
      restriction_node.build
    end
    restriction_node[0].beginDate = val
  end
  def restrictionEndDate
    restriction_node[0] ? restriction_node[0].endDate : []
  end
  def restrictionEndDate=(val)
    if restriction_node[0] == nil
      restriction_node.build
    end
    restriction_node[0].endDate = val
  end
  def restrictionType
    restriction_node[0] ? restriction_node[0].type : []
  end
  def restrictionType=(val)
    if restriction_node[0] == nil
      restriction_node.build
    end
    restriction_node[0].type = val
  end  

end
