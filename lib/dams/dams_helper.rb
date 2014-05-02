require 'active_support/inflector'

module Dams
	module DamsHelper
	    
	  ## Title ######################################################################
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
	    title.first.value if title.first
	  end
	  def titleValue=(s)
	    title.build if title.first.nil?
	    if(!s.nil? && s.length > 0)
	      title.first.value = s
	    end
	  end
	  def subtitle
	    title.first.subtitle if title.first
	  end
	  def subtitle=(s)
	    title.build if title.first.nil?
	    title.first.subtitle = s
	  end
	  def titlePartName
	    title.first != nil ? title.first.partName : nil
	  end
	  def titlePartName=(s)
	    title.build if title.first.nil?
	    title.first.partName = s
	  end
	  def titlePartNumber
	    title.first != nil ? title.first.partNumber : nil
	  end
	  def titlePartNumber=(s)
	    title.build if title.first.nil?
	    title.first.partNumber = s
	  end  

	   def titleNonSort
	    title.first != nil ? title.first.nonSort : nil
	  end
	  def titleNonSort=(s)
	    title.build if title.first.nil?
	    title.first.nonSort = s
	  end

	  def titleVariant
	    title.first != nil ? title.first.variant : nil
	  end
	  def titleVariant=(s)
	    title.build if title.first.nil?
	    title.first.variant = s
	  end
	  
	  def titleTranslationVariant
	    title.first != nil ? title.first.translationVariant : nil
	  end
	  def titleTranslationVariant=(s)
	    title.build if title.first.nil?
	    title.first.translationVariant = s
	  end 
	  
	  def titleAbbreviationVariant
	    title.first != nil ? title.first.abbreviationVariant : nil
	  end
	  def titleAbbreviationVariant=(s)
	    title.build if title.first.nil?
	    title.first.abbreviationVariant = s
	  end 
	  
	  def titleAcronymVariant
	    title.first != nil ? title.first.acronymVariant : nil
	  end
	  def titleAcronymVariant=(s)
	    title.build if title.first.nil?
	    title.first.acronymVariant = s
	  end 

	  def titleExpansionVariant
	    title.first != nil ? title.first.expansionVariant : nil
	  end
	  def titleExpansionVariant=(s)
	    title.build if title.first.nil?
	    title.first.expansionVariant = s
	  end 
	                 
	  ## Subject ######################################################################
	  #simple subject
	  def subjectType
	    @subType
	  end
	  def subjectType=(val)
	    @subType = Array.new
	    i = 0
		val.each do |v| 
		    if(!v.nil? && v.length > 0)
		    	@subType << v 	
		    end
			i+=1
		end
	  end

	  def simpleSubjectURI
	    if @simpleSubURI != nil
	      @simpleSubURI
	    end
	  end 
	  def simpleSubjectURI=(val)
		@simpleSubURI = Array.new
		val.each do |v|
			uri = v
			if(!v.include? Rails.configuration.id_namespace)
				uri = "#{Rails.configuration.id_namespace}#{v}"
			end
		    if(!v.nil? && v.length > 0)
		    	@simpleSubURI << RDF::Resource.new(uri) 	
		    end
		end
	  end


	  ## complex subject  ###############################################################
	    
	  def subjectURI=(val)
		@subURI = Array.new
		@array_subject = Array.new
		val.each do |v|
			uri = v
			if(!v.include? Rails.configuration.id_namespace)
				uri = "#{Rails.configuration.id_namespace}#{v}"
			end
		    if(!v.nil? && v.length > 0)
		    	@subURI << RDF::Resource.new(uri) 	
		    	@array_subject << RDF::Resource.new(uri) 
		    end
		end
			
		if(@subURI.size == 0)
			@subURI = nil
			@array_subject = nil
		end
	  end
	  
	  def subjectURI
	    if @subURI != nil
	      @subURI
	    end
	  end  

	  ## Name ###########################################################################
	  def nameType
	    @namesType
	  end
	  def nameType=(val)
	    @namesType = Array.new
	    i = 0
			val.each do |v| 
			    if(!v.nil? && v.length > 0)
			    	 @namesType << v 	
			    end
				i+=1
			end
	  end  

	  def nameURI
	    if @name_URI != nil
	      @name_URI
	    end
	  end 
	  def nameURI=(val)
	    if val.class == Array
	    	val = val.first
	    end
		 if(!val.nil? && val.first.length > 0)
		    @name_URI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")   	
		  end
	  end

	  #Creator
	  def creatorURI
	    if @creatorURI != nil
	      @creatorURI
	    end
	  end 
	  def creatorURI=(val)
	  @creatorURI = Array.new
	  val.each do |v|
	    uri = v
	    if(!v.include? Rails.configuration.id_namespace)
	      uri = "#{Rails.configuration.id_namespace}#{v}"
	    end
	      if(!v.nil? && v.length > 0)
	        @creatorURI << RDF::Resource.new(uri)   
	      end
	  end
	  end
	  
	    
	  ## Language ######################################################################  
	  def languageURI
	    if @langURI != nil
	      @langURI
	    end
	  end 
	  def languageURI=(val)
	    if val.class == Array
	    	#	val = val.first
			@langURI = Array.new
			val.each do |v|
				uri = v
				if(!v.include? Rails.configuration.id_namespace)
					uri = "#{Rails.configuration.id_namespace}#{v}"
				end
			    if(!v.nil? && v.length > 0)
			    	@langURI << RDF::Resource.new(uri) 	
			    end
			end  	
		end
		if(@langURI.size == 1)
			@langURI = @langURI.first
		end
	  end

	  ## RelatedResource ######################################################################  
	  def relResourceURI
	    if @relResourceURI != nil
	      @relResourceURI
	    end
	  end 
	  def relResourceURI=(val)
	    if val.class == Array
	    	#	val = val.first
			@relResourceURI = Array.new
			val.each do |v|
				uri = v
				if(!v.include? Rails.configuration.id_namespace)
					uri = "#{Rails.configuration.id_namespace}#{v}"
				end
			    if(!v.nil? && v.length > 0)
			    	@relResourceURI << RDF::Resource.new(uri) 	
			    end
			end  	
		end
		if(@relResourceURI.size == 1)
			@lrelResourceURI = @relResourceURI.first
		end
	  end
	  	 
	  ## Unit ######################################################################
	  def unitURI=(val)
	    if val.class == Array
	    	val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	    	@unitURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
	    end
	  end
	  def unitURI
	    if @unitURI != nil
	      @unitURI
	    #else
	    #  unitURI.first
	    end
	  end     

	  ## Collection ######################################################################

	  def assembledCollectionURI=(val)
	  if val.class == Array
	      # val = val.first
	    @assembledCollURI = Array.new
	    val.each do |v|
	      uri = v
	      if(!v.include? Rails.configuration.id_namespace)
	        uri = "#{Rails.configuration.id_namespace}#{v}"
	      end
	        if(!v.nil? && v.length > 0)
	          @assembledCollURI << RDF::Resource.new(uri)  
	        end
	    end   
	  end
	  if(@assembledCollURI.size == 1)
	    @assembledCollURI = @assembledCollURI.first
	  end
	  end
	  
	  def assembledCollectionURI
	    if @assembledCollURI != nil
	      @assembledCollURI
	    end
	  end  

	  def provenanceCollectionURI=(val)
	    if val.class == Array
	    	val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	    	@provenanceCollURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
	    end
	  end
	  def provenanceCollectionURI
	    if @provenanceCollURI != nil
	      @provenanceCollURI
	   # else
	   #   provenanceCollectionURI.first
	    end
	  end      
	  
	 	def provenanceCollectionPartURI=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      @provenanceCollPartURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
	    end
	  end
	  def provenanceCollectionPartURI
	    if @provenanceCollPartURI != nil
	      @provenanceCollPartURI
	    
	    end
	  end     

	  def provenanceHasCollPartURI=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      @provenanceHasPartURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
	    end
	  end
	  def provenanceHasCollPartURI
	    if @provenanceHasPartURI != nil
	      @provenanceHasPartURI
	    
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

	  ## ElementListValue for MADS classes ######################################################################
	  def getElementValue(type)
	    elem = find_element type
	    if elem != nil
	      elem.elementValue.first
	    else
	      []
	    end
	  end
	  
	  def setElementValue(type,val)
	    if val.class == Array
	        val = val.first
	    end

	    if elementList[0] == nil
	      elementList.build
	    end

	    existing_elem = find_element type

	    #need to use eList.size to know where to insert/update the value
	    if(existing_elem != nil )
	      # set value of existing element
	      existing_elem.elementValue = val
	    else
	      # create a new element of the correct type
	      if type.include? "TopicElement"
	        elem = MadsDatastream::List::TopicElement.new(elementList.first.graph)
	      elsif type.include? "BuiltWorkPlaceElement"
	        elem = DamsDatastream::List::BuiltWorkPlaceElement.new(elementList.first.graph)
		  elsif type.include? "CulturalContextElement"
	        elem = DamsDatastream::List::CulturalContextElement.new(elementList.first.graph)
	      elsif type.include? "FunctionElement"
	        elem = DamsDatastream::List::FunctionElement.new(elementList.first.graph)
		  elsif type.include? "GenreFormElement"
	        elem = MadsDatastream::List::GenreFormElement.new(elementList.first.graph)              
	      elsif type.include? "GeographicElement"
	        elem = MadsDatastream::List::GeographicElement.new(elementList.first.graph)
		  elsif type.include? "IconographyElement"
	        elem = DamsDatastream::List::IconographyElement.new(elementList.first.graph)
	      elsif type.include? "StylePeriodElement"
	        elem = DamsDatastream::List::StylePeriodElement.new(elementList.first.graph)
		  elsif type.include? "ScientificNameElement"
	        elem = MadsDatastream::List::ScientificNameElement.new(elementList.first.graph)
	      elsif type.include? "TechniqueElement"
	        elem = DamsDatastream::List::TechniqueElement.new(elementList.first.graph)
		  elsif type.include? "TemporalElement"
	        elem = MadsDatastream::List::TemporalElement.new(elementList.first.graph)     
		  elsif type.include? "OccupationElement"
	        elem = MadsDatastream::List::OccupationElement.new(elementList.first.graph)               
	      elsif type.include? "DateNameElement"
	        elem = Dams::MadsNameElements::MadsDateNameElement.new(elementList.first.graph)
	      elsif type.include? "FamilyNameElement"
	        elem = Dams::MadsNameElements::MadsFamilyNameElement.new(elementList.first.graph)
	      elsif type.include? "FullNameElement"
	        elem = Dams::MadsNameElements::MadsFullNameElement.new(elementList.first.graph)
	      elsif type.include? "GivenNameElement"
	        elem = Dams::MadsNameElements::MadsGivenNameElement.new(elementList.first.graph)
	      elsif type.include? "TermsOfAddressNameElement"
	        elem = Dams::MadsNameElements::MadsTermsOfAddressNameElement.new(elementList.first.graph)
		  elsif type.include? "NameElement"
	        elem = Dams::MadsNameElements::MadsNameElement.new(elementList.first.graph)                                                  
	      end
	      elem.elementValue = val

	      # add new element to the end of the list
	      if elementList.first.nil?
	        elementList.first.value = elem
	      else
	        elementList.first[elementList.first.size] = elem
	      end
	    end 
	  end
	  
	  def find_element( type )
	    chain = elementList.first
	    elem = nil
	    while  elem == nil && chain != nil do
	      if chain.first.class.name.include? type
	        elem = chain.first
	      else
	        chain = chain.tail
	      end
	    end
	    elem
	  end 
	  
	  ##  MADS Name classes ######################################################################
	 
	  def nameValue
	    getElementValue "NameElement"
	  end
	  
	  def nameValue=(s)
	    setElementValue( "NameElement", s )
	  end
	   
	  def fullNameValue
	    getElementValue "FullNameElement"
	  end
	  
	  def fullNameValue=(s)
	    setElementValue( "FullNameElement", s )
	  end  
	  
	  def familyNameValue
	    getElementValue "FamilyNameElement"
	  end
	  
	  def familyNameValue=(s)
	    setElementValue( "FamilyNameElement", s )
	  end    
	  
	  def givenNameValue
	    getElementValue "GivenNameElement"
	  end
	  
	  def givenNameValue=(s)
	    setElementValue( "GivenNameElement", s )
	  end    
	  
	  def dateNameValue
	    getElementValue "DateNameElement"
	  end
	  
	  def dateNameValue=(s)
	    setElementValue( "DateNameElement", s )
	  end    
	  
	  ##  Relationship ###################################################################### 
	  
	  def relationshipRoleURI
	    relationship[0] ? relationship[0].role : []
	  end 
	  def relationshipRoleURI=(val)
		  i = 0
		  val.each do |v|
		    uri = v
		    if(!v.include? Rails.configuration.id_namespace)
		      uri = "#{Rails.configuration.id_namespace}#{v}"
		    end
		    if(!v.nil? && v.length > 0)
		      @roleURI = RDF::Resource.new(uri)
			  if relationship[i] == nil
	       		relationship.build
		      end	      

		      relationship[i].role = @roleURI 
		    end	    
		    i+=1
		  end       	  
	  end   
	  
	  def relationshipNameURI
		relationship[0] ? relationship[0].name : []
	  end
	  
	  def relationshipNameURI=(val)
		  i = 0
		  val.each do |v|
		    uri = v
		    if(!v.include? Rails.configuration.id_namespace)
		      uri = "#{Rails.configuration.id_namespace}#{v}"
		    end
		    if(!v.nil? && v.length > 0)
		      relNameURI = RDF::Resource.new(uri)
			  if relationship[i] == nil
	       	  	relationship.build
		      end
		      if( !@relNameType.nil? && !@relNameType[i].nil? && (@relNameType[i].include? 'CorporateName')) 
		    	relationship[i].corporateName = relNameURI 
		      elsif( !@relNameType.nil? && !@relNameType[i].nil? && (@relNameType[i].include? 'PersonalName')) 
		    	relationship[i].personalName = relNameURI
		      elsif( !@relNameType.nil? && !@relNameType[i].nil? && (@relNameType[i].include? 'ConferenceName')) 
		    	relationship[i].conferenceName = relNameURI
		      elsif( !@relNameType.nil? && !@relNameType[i].nil? && (@relNameType[i].include? 'FamilyName')) 
		    	relationship[i].familyName = relNameURI	    		    	     
		      elsif( !@relNameType.nil? && !@relNameType[i].nil? && (@relNameType[i].include? 'Name')) 
		    	relationship[i].name = relNameURI       		   
		      end	         
		    end	    
		    i+=1
			end
	  end   
	  
	  def relationshipNameType
	    @relNameType
	  end
	  def relationshipNameType=(val)
	    @relNameType = Array.new
	    i = 0
		val.each do |v| 
		    if(!v.nil? && v.length > 0)
		    	@relNameType << v 	
		    end
			i+=1
		end
	  end
	  
	  ## Cartographics ######################################################################
	  def cartographicPoint
	    cartographics[0] ? cartographics[0].point : []
	  end
	  def cartographicPoint=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      cartographics.build if cartographics[0] == nil
	      cartographics[0].point = val
	    end
	  end

	  def cartographicLine
	    cartographics[0] ? cartographics[0].line : []
	  end
	  def cartographicLine=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      cartographics.build if cartographics[0] == nil
	      cartographics[0].line = val
	    end
	  end  
	  
	  def cartographicPolygon
	    cartographics[0] ? cartographics[0].polygon : []
	  end
	  def cartographicPolygon=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      cartographics.build if cartographics[0] == nil
	      cartographics[0].polygon = val
	    end
	  end  
	  
	  def cartographicProjection
	    cartographics[0] ? cartographics[0].projection : []
	  end
	  def cartographicProjection=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      cartographics.build if cartographics[0] == nil
	      cartographics[0].projection = val
	    end
	  end 
	  
	  def cartographicRefSystem
	    cartographics[0] ? cartographics[0].referenceSystem : []
	  end
	  def cartographicRefSystem=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      cartographics.build if cartographics[0] == nil
	      cartographics[0].referenceSystem = val
	    end
	  end
	  
	  def cartographicScale
	    cartographics[0] ? cartographics[0].scale : []
	  end
	  def cartographicScale=(val)
	    if val.class == Array
	      val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	      cartographics.build if cartographics[0] == nil
	      cartographics[0].scale = val
	    end
	  end      
	  
	  ## Rights
	   ######################################################################
	  def copyrightURI=(val)
	    if val.class == Array
	    	val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	    	@rightURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
	    end
	  end
	  def copyrightURI
	    if @rightURI != nil
	      @rightURI
	    end
	  end      

	  def statuteURI=(val)
	    if val.class == Array
	    	val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	    	@statURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
	    end
	  end
	  def statuteURI
	    if @statURI != nil
	      @statURI
	    end
	  end 
	  
	  def otherRightsURI=(val)
	    if val.class == Array
	    	val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	    	@otherCopyRightURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
	    end
	  end
	  def otherRightsURI
	    if @otherCopyRightURI != nil
	      @otherCopyRightURI
	    end
	  end 
	  
	  def licenseURI=(val)
	    if val.class == Array
	    	val = val.first
	    end
	    if(!val.nil? && val.length > 0)
	    	@licenURI = RDF::Resource.new("#{Rails.configuration.id_namespace}#{val}")
	    end
	  end
	  def licenseURI
	    if @licenURI != nil
	      @licenURI
	    end
	  end 
	  
	  #RightsHolder ###################
	  def rightsHolderURI=(val)
		 @holderURI = Array.new
		  val.each do |v|
		    uri = v
		    if(!v.include? Rails.configuration.id_namespace)
		      uri = "#{Rails.configuration.id_namespace}#{v}"
		    end
		      if(!v.nil? && v.length > 0)
		        @holderURI << RDF::Resource.new(uri)   
		      end
		  end
	  end
	  def rightsHolderURI
	    if @holderURI != nil
	      @holderURI
	    end
	  end   
	
	  def rightsHolderType
	    @rightsHolderType
	  end
	  def rightsHolderType=(val)
	    @rightsHolderType = Array.new
	    i = 0
		val.each do |v| 
		    if(!v.nil? && v.length > 0)
		    	 @rightsHolderType << v 	
		    end
			i+=1
		end
	  end      
  
    # Unload and reload a class to reset any broken mappings
    def reload( klazz )
      begin
        Object.send(:remove_const, klazz.to_s) if defined? klazz
        load "#{ActiveSupport::Inflector.underscore(klazz)}.rb"
      rescue Exception => ex
        puts "Error reloading class (#{klazz.to_s}): #{ex}"
      end
    end

  end
end
