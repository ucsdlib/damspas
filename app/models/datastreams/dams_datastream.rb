class DamsDatastream < ActiveFedora::RdfxmlRDFDatastream
    
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

  def scheme=(val)
    if val.class == Array
     val = val.first
    end
    @madsScheme = RDF::Resource.new(Rails.configuration.id_namespace+val)
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
    @extAuthority = RDF::Resource.new(val)
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
    class IconographyElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type DAMS.IconographyElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end
    class ScientificNameElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type DAMS.ScientificNameElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end    
    class TechniqueElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type DAMS.TechniqueElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end        
    class BuiltWorkPlaceElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type DAMS.BuiltWorkPlaceElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end   
    class CulturalContextElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type DAMS.CulturalContextElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end       
    class StylePeriodElement
      include ActiveFedora::RdfObject
      include ActiveFedora::Rdf::DefaultNodes
      rdf_type DAMS.StylePeriodElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end          
  end
    
  def to_solr (solr_doc = {}) 
    Solrizer.insert_field(solr_doc, 'name', name)
	Solrizer.insert_field(solr_doc, 'scheme', scheme.to_s)
    if scheme.to_s != nil
      scheme_id = scheme.to_s.gsub(/.*\//,'')
      schobj = MadsScheme.find( scheme_id )
      Solrizer.insert_field(solr_doc, 'scheme_name', schobj.name.first)
      Solrizer.insert_field(solr_doc, 'scheme_code', schobj.code.first)
    end
    Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.to_s)

	list = elementList.first
	i = 0
	if list != nil
		while i < list.size  do
		  if (list[i].class == DamsDatastream::List::IconographyElement)
			Solrizer.insert_field(solr_doc, 'iconography_element', list[i].elementValue.first)	
		  elsif (list[i].class == DamsDatastream::List::ScientificNameElement)
			Solrizer.insert_field(solr_doc, 'scientificName_element', list[i].elementValue.first)	
		  elsif (list[i].class == DamsDatastream::List::TechniqueElement)
			Solrizer.insert_field(solr_doc, 'technique_element', list[i].elementValue.first)	
		  elsif (list[i].class == DamsDatastream::List::BuiltWorkPlaceElement)
			Solrizer.insert_field(solr_doc, 'builtWorkPlace_element', list[i].elementValue.first)	
		  elsif (list[i].class == DamsDatastream::List::CulturalContextElement)
			Solrizer.insert_field(solr_doc, 'culturalContext_element', list[i].elementValue.first)		
		  elsif (list[i].class == DamsDatastream::List::StylePeriodElement)
			Solrizer.insert_field(solr_doc, 'stylePeriod_element', list[i].elementValue.first)																																	
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

