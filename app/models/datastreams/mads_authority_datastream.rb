class MadsAuthorityDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.code( in: MADS )
    map.name( in: MADS, to: "authoritativeLabel" )
    map.description( in: MADS, to: "definitionNote" )
    map.externalAuthorityNode( in: MADS, to: "hasExactExternalAuthority" )
    map.schemeNode( in: MADS, to: "isMemberOfMADSScheme" )
  end
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.MadsAuthority]) if new?
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
  def to_solr(solr_doc ={})
    super( solr_doc )
    Solrizer.insert_field(solr_doc, "name", name.first )
    Solrizer.insert_field(solr_doc, "code", code.first )
    Solrizer.insert_field(solr_doc, "description", code.first )
    Solrizer.insert_field(solr_doc, "externalAuthority", externalAuthority.to_s)
    scheme_obj = scheme
    if scheme_obj.class == Array
      scheme_obj = scheme_obj.first
    end
    scheme_id = scheme_obj.to_s.gsub /.*\//, ""   
    if scheme_id != nil && scheme_id.length > 0
      Solrizer.insert_field(solr_doc, "scheme", "#{Rails.configuration.id_namespace}#{scheme_id}")
      scheme_id = scheme_id.gsub(/.*\//,'')
      schobj = MadsScheme.find( scheme_id )
      Solrizer.insert_field(solr_doc, 'scheme_name', schobj.name.first)
      Solrizer.insert_field(solr_doc, 'scheme_code', schobj.code.first)
    end

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }

    # hack to make sure something is indexed for rights metadata
    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
      solr_doc[f] = 'dams-curator' unless solr_doc[f]
    }
    return solr_doc
  end
end
