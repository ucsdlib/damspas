class MadsComplexSubjectInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type MADS.ComplexSubject
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.scheme(:in => MADS, :to => 'isMemberOfMADSScheme')
    map.externalAuthorityNode(:in => MADS, :to => 'hasExactExternalAuthority')
    map.componentList(:in => MADS, :to => 'componentList', :class_name=>'ComponentList')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
  end
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

  def external?
    rdf_subject.to_s.include? Rails.configuration.id_namespace
  end
    
  def load
      uri = rdf_subject.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        MadsComplexSubject.find(md[1])
      end
  end
end
