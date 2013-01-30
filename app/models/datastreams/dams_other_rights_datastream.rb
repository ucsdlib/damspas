class DamsOtherRightsDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.basis(:in => DAMS, :to => 'otherRightsBasis')
    map.note(:in => DAMS, :to => 'otherRightsNote')
    map.uri(:in => DAMS, :to => 'otherRightsURI')
    map.restriction(:in => DAMS, :to=>'restriction', :class_name => 'Restriction')
    map.permission(:in => DAMS, :to=>'permission', :class_name => 'Permission')
#    map.relationship(:in => DAMS, :class_name => 'Relationship')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.repository_root + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.OtherRights]) if new?
    super
  end

  def permissionBeginDate
    permission[0] ? permission[0].beginDate : []
  end
  def permissionBeginDate=(val)
    if permission[0] == nil
      permission[0] = permission.build
    end
    permission[0].beginDate = val
  end
  def permissionEndDate
    permission[0] ? permission[0].endDate : []
  end
  def permissionEndDate=(val)
    if permission[0] == nil
      permission[0] = permission.build
    end
    permission[0].endDate = val
  end
  def permissionType
    permission[0] ? permission[0].type : []
  end
  def permissionType=(val)
    if permission[0] == nil
      permission[0] = permission.build
    end
    permission[0].type = val
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
    restriction[0] ? restriction[0].beginDate : []
  end
  def restrictionBeginDate=(val)
    if restriction[0] == nil
      restriction[0] = restriction.build
    end
    restriction[0].beginDate = val
  end
  def restrictionEndDate
    restriction[0] ? restriction[0].endDate : []
  end
  def restrictionEndDate=(val)
    if restriction[0] == nil
      restriction[0] = restriction.build
    end
    restriction[0].endDate = val
  end
  def restrictionType
    restriction[0] ? restriction[0].type : []
  end
  def restrictionType=(val)
    if restriction[0] == nil
      restriction[0] = restriction.build
    end
    restriction[0].type = val
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

#  def decider
#    relationship[0] ? relationship[0].name : []
#  end
#  def decider=(val)
#    if relationship[0] == nil
#      relationship[0] = relationship.build
#    end
#    name = MadsName.find( val )
#    role = DamsRole.find( 'bbXXXXXXX2' )
#    relationship[0].name = name
#    relationship[0].role = role
#  end
#  class Relationship
#    include ActiveFedora::RdfObject
#    rdf_type DAMS.Relationship
#    map_predicates do |map|
#      map.name(:in=> DAMS)
#      map.role(:in=> DAMS)
#    end
#
#    def load
#      uri = name.first.to_s
#      md = /\/(\w*)$/.match(uri)
#      DamsPerson.find(md[1])
#    end
#  end

  def to_solr (solr_doc = {})
    solr_doc[ActiveFedora::SolrService.solr_name("basis", type: :text)] = basis
    solr_doc[ActiveFedora::SolrService.solr_name("uri", type: :text)] = uri
    solr_doc[ActiveFedora::SolrService.solr_name("note", type: :text)] = note

    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
    }
    return solr_doc
  end
end
