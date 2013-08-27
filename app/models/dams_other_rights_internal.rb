class DamsOtherRightsInternal
  include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
  include DamsHelper
  rdf_type DAMS.OtherRights
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.basis(:in => DAMS, :to => 'otherRightsBasis')
    map.note(:in => DAMS, :to => 'otherRightsNote')
    map.uri(:in => DAMS, :to => 'otherRightsURI')
    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'DamsRestriction')
    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'DamsPermission')
    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
 end

  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end  
  
  def name
    relationship[0] ? relationship[0].name : []
  end
  def name=(val)
    if relationship[0] == nil
      relationship[0] = relationship.build
    end
    relationship[0].name = RDF::Resource.new(val)
  end
  def role
    relationship[0] ? relationship[0].role : []
  end
  def role=(val)
    if relationship[0] == nil
      relationship[0] = relationship.build
    end
    relationship[0].role = RDF::Resource.new(val)
  end    
end
