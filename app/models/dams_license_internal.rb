class DamsLicenseInternal
  include ActiveFedora::RdfObject
  include DamsHelper
  rdf_type DAMS.License
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.note(:in => DAMS, :to => 'licenseNote')
    map.uri(:in => DAMS, :to => 'licenseURI')
    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'Restriction')
    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'Permission')
 end

  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end  
end
