class DamsOtherRightsDatastream < ActiveFedora::RdfxmlRDFDatastream
  include DamsHelper
  map_predicates do |map|
    map.basis(:in => DAMS, :to => 'otherRightsBasis')
    map.note(:in => DAMS, :to => 'otherRightsNote')
    map.uri(:in => DAMS, :to => 'otherRightsURI')
    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'DamsRestriction')
    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'DamsPermission')
    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.OtherRights]) if new?
    super
  end

  def name
    relationship[0] ? relationship[0].name : []
  end
  def name=(val)
    if relationship[0] == nil
      relationship.build
    end
    relationship[0].name = RDF::Resource.new(val)
  end
  def role
    relationship[0] ? relationship[0].role : []
  end
  def role=(val)
    if relationship[0] == nil
      relationship.build
    end
    relationship[0].role = RDF::Resource.new(val)
  end   

  def to_solr (solr_doc = {})
    solr_doc[ActiveFedora::SolrService.solr_name("basis", type: :text)] = basis
    solr_doc[ActiveFedora::SolrService.solr_name("uri", type: :text)] = uri
    solr_doc[ActiveFedora::SolrService.solr_name("note", type: :text)] = note
    relationship.map do |relationship|
      Solrizer.insert_field(solr_doc, 'decider', relationship.load.name )
    end

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end
end
