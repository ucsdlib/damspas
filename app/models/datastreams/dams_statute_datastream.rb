class DamsStatuteDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.citation(:in => DAMS, :to => 'statuteCitation')
    map.jurisdiction(:in => DAMS, :to => 'statuteJurisdiction')
    map.note(:in => DAMS, :to => 'statuteNote')
    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'Restriction')
    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'Permission')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.repository_root + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Statute]) if new?
    super
  end

  def permissionBeginDate
    permission_node[0] ? permission_node[0].beginDate : []
  end
  def permissionBeginDate=(val)
    if permission_node[0] == nil
      permission_node[0] = permission_node.build
    end
    permission_node[0].beginDate = val
  end
  def permissionEndDate
    permission_node[0] ? permission_node[0].endDate : []
  end
  def permissionEndDate=(val)
    if permission_node[0] == nil
      permission_node[0] = permission_node.build
    end
    permission_node[0].endDate = val
  end
  def permissionType
    permission_node[0] ? permission_node[0].type : []
  end
  def permissionType=(val)
    if permission_node[0] == nil
      permission_node[0] = permission_node.build
    end
    permission_node[0].type = val
  end
  class Permission
    include ActiveFedora::RdfObject
    rdf_type DAMS.Permission
    map_predicates do |map|
      map.type(:in=>DAMS)
      map.beginDate(:in=>DAMS)
      map.endDate(:in=>DAMS)
    end
  end

  def restrictionBeginDate
    restriction_node[0] ? restriction_node[0].beginDate : []
  end
  def restrictionBeginDate=(val)
    if restriction_node[0] == nil
      restriction_node[0] = restriction_node.build
    end
    restriction_node[0].beginDate = val
  end
  def restrictionEndDate
    restriction_node[0] ? restriction_node[0].endDate : []
  end
  def restrictionEndDate=(val)
    if restriction_node[0] == nil
      restriction_node[0] = restriction_node.build
    end
    restriction_node[0].endDate = val
  end
  def restrictionType
    restriction_node[0] ? restriction_node[0].type : []
  end
  def restrictionType=(val)
    if restriction_node[0] == nil
      restriction_node[0] = restriction_node.build
    end
    restriction_node[0].type = val
  end
  class Restriction
    include ActiveFedora::RdfObject
    rdf_type DAMS.Restriction
    map_predicates do |map|
      map.type(:in=>DAMS)
      map.beginDate(:in=>DAMS)
      map.endDate(:in=>DAMS)
    end
  end

  def to_solr (solr_doc = {})
    solr_doc[ActiveFedora::SolrService.solr_name("citation", type: :text)] = citation
    solr_doc[ActiveFedora::SolrService.solr_name("jurisdiction", type: :text)] = jurisdiction
    solr_doc[ActiveFedora::SolrService.solr_name("note", type: :text)] = note

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end
end
