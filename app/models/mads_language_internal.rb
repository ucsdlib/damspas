class MadsLanguageInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type MADS.Language
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.code(:in => MADS)
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
    map.scheme( in: MADS, to: "isMemberOfMADSScheme" )
  end 
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
