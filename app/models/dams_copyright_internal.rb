class DamsCopyrightInternal
  include ActiveFedora::RdfObject
  include DamsHelper
  rdf_type DAMS.Copyright
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.status(:in => DAMS, :to => 'copyrightStatus')
    map.jurisdiction(:in => DAMS, :to => 'copyrightJurisdiction')
    map.purposeNote(:in => DAMS, :to => 'copyrightPurposeNote')
    map.note(:in => DAMS, :to => 'copyrightNote')
    map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
  end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end  
end
