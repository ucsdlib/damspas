class MadsDatastream < ActiveFedora::RdfxmlRDFDatastream
  include DamsHelper
  def scheme=(val)
    if val.class == Array
     val = val.first
    end
    if(val != nil && val.length > 0)
    	@madsScheme = RDF::Resource.new(Rails.configuration.id_namespace+val)
    end
  end
  def scheme
    if @madsScheme != nil
      @madsScheme
    else
      schemeNode.first
    end
  end

  def externalAuthority=(val)
    if val.class == Array
     val = val.first
    end
    if(val != nil && val.length > 0)
     	@extAuthority = RDF::Resource.new(val)
     end
  end
  def externalAuthority
    if @extAuthority != nil
      @extAuthority
    elsif !externalAuthorityNode.nil? 
      externalAuthorityNode.first
    else
    	nil
    end
  end
           
  class List 
    include ActiveFedora::RdfList
    class GenreFormElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type MADS.GenreFormElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end    
    class OccupationElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type MADS.OccupationElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end       
#    class TemporalElement
#      include ActiveFedora::RdfObject
#      include ActiveFedora::Rdf::DefaultNodes
#      rdf_type MADS.TemporalElement
#      map_predicates do |map|   
#        map.elementValue(:in=> MADS)
#      end
#    end          

    # language element
    class LanguageElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type MADS.LanguageElement
      map_predicates do |map|
        map.elementValue(:in=> MADS)
      end
    end
    
    class MainTitleElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type MADS.MainTitleElement
      map_predicates do |map|
        map.elementValue(:in=> MADS)
      end
    end    
    
    class NonSortElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type MADS.NonSortElement
      map_predicates do |map|
        map.elementValue(:in=> MADS)
      end
    end        

    class PartNameElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type MADS.PartNameElement
      map_predicates do |map|
        map.elementValue(:in=> MADS)
      end
    end      
    
    class PartNumberElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type MADS.PartNumberElement
      map_predicates do |map|
        map.elementValue(:in=> MADS)
      end
    end    

    class SubTitleElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type MADS.SubTitleElement
      map_predicates do |map|
        map.elementValue(:in=> MADS)
      end
    end      
  end
    
 rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    if(!externalAuthority.nil?)
      if new?
        graph.insert([rdf_subject, MADS.hasExactExternalAuthority, externalAuthority])
      else
        graph.update([rdf_subject, MADS.hasExactExternalAuthority, externalAuthority])
      end
    end 
    if(!scheme.nil?)
      if new?
        graph.insert([rdf_subject, MADS.isMemberOfMADSScheme, scheme])
      else
        graph.update([rdf_subject, MADS.isMemberOfMADSScheme, scheme])
      end
    end
    super
  end
  
  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'name', name)
    if scheme != nil && scheme.class.name.include?("MadsSchemeInternal")
	  Solrizer.insert_field(solr_doc, 'scheme', scheme.rdf_subject.to_s)
      Solrizer.insert_field(solr_doc, 'scheme_name', scheme.name.first)
      Solrizer.insert_field(solr_doc, 'scheme_code', scheme.code.first)
    else
	  Solrizer.insert_field(solr_doc, 'scheme', scheme.to_s)
      if !scheme.to_s.blank? 
        scheme_id = scheme.to_s.gsub(/.*\//,'')
        schobj = MadsScheme.find( scheme_id )
        Solrizer.insert_field(solr_doc, 'scheme_name', schobj.name.first)
        Solrizer.insert_field(solr_doc, 'scheme_code', schobj.code.first)
      end
    end
 	Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.to_s)
 	
	list = elementList.first
	i = 0
	if list != nil
		while i < list.size  do
		  if (list[i].class == MadsFullNameElement)
			Solrizer.insert_field(solr_doc, 'full_name_element', list[i].elementValue.first)
	 	  elsif (list[i].class == MadsFamilyNameElement)
			Solrizer.insert_field(solr_doc, 'family_name_element', list[i].elementValue.first)		
		  elsif (list[i].class == MadsGivenNameElement)
			Solrizer.insert_field(solr_doc, 'given_name_element', list[i].elementValue.first)				
		  elsif (list[i].class == MadsDateNameElement)
			Solrizer.insert_field(solr_doc, 'date_name_element', list[i].elementValue.first)	
		  elsif (list[i].class == MadsNameElement)
			Solrizer.insert_field(solr_doc, 'name_element', list[i].elementValue.first)	
  		  elsif (list[i].class == MadsTermsOfAddressNameElement)
			Solrizer.insert_field(solr_doc, 'terms_of_address_name_element', list[i].elementValue.first)		
 		  elsif (list[i].class == MadsDatastream::List::GenreFormElement)
			Solrizer.insert_field(solr_doc, 'genre_form_element', list[i].elementValue.first)	
		  #elsif (list[i].class == MadsDatastream::List::GeographicElement)
			#Solrizer.insert_field(solr_doc, 'geographic_element', list[i].elementValue.first)		
		  elsif (list[i].class == MadsDatastream::List::OccupationElement)
			Solrizer.insert_field(solr_doc, 'occupation_element', list[i].elementValue.first)		
		  #elsif (list[i].class == MadsDatastream::List::TemporalElement)
		   #Solrizer.insert_field(solr_doc, 'temporal_element', list[i].elementValue.first)		
		  # elsif (list[i].class == MadsDatastream::List::TopicElement)
			# Solrizer.insert_field(solr_doc, 'topic_element', list[i].elementValue.first)															
		  elsif (list[i].class == MadsDatastream::List::LanguageElement)
			Solrizer.insert_field(solr_doc, 'language_element', list[i].elementValue.first)																			
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

