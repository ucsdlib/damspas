class DamsStatuteInternal
  include ActiveFedora::RdfObject
  include DamsHelper
  rdf_type DAMS.Statute
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.citation(:in => DAMS, :to => 'statuteCitation')
    map.jurisdiction(:in => DAMS, :to => 'statuteJurisdiction')
    map.note(:in => DAMS, :to => 'statuteNote')
    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'DamsRestriction')
    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'DamsPermission')
 end

  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end  
 
end
