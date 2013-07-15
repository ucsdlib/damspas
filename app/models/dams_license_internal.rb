class DamsLicenseInternal
  include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
  include DamsHelper
  rdf_type DAMS.License
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.note(:in => DAMS, :to => 'licenseNote')
    map.uri(:in => DAMS, :to => 'licenseURI')
    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'DamsRestriction')
    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'DamsPermission')
 end

  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end  
end
