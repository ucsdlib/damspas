class DamsProvenanceCollectionPartDatastream < DamsResourceDatastream
  map_predicates do |map|
    map.title_node(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.odate(:in => DAMS, :to=>'date', :class_name => 'Date')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'ScopeContentNote')
    map.note(:in => DAMS, :to=>'note', :class_name => 'Note')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.subject_node(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.language(:in=>DAMS)
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'CustodialResponsibilityNote')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'PreferredCitationNote')   
    map.occupation(:in => DAMS)
    map.genreForm(:in => DAMS)
    map.iconography(:in => DAMS)
    map.scientificName(:in => DAMS)
    map.technique(:in => DAMS)
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'ScopeContentNote')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'PreferredCitationNote')
    map.familyName(:in => DAMS)
    map.name(:in => DAMS)
    map.builtWorkPlace(:in => DAMS)
    map.personalName(:in => DAMS)
    map.geographic(:in => DAMS)
    map.temporal(:in => DAMS)
    map.culturalContext(:in => DAMS)
    map.stylePeriod(:in => DAMS)
    map.topic(:in => DAMS)
    map.conferenceName(:in => DAMS)
    map.function(:in => DAMS)
    map.corporateName(:in => DAMS)
    map.complexSubject(:in => DAMS)
    map.event(:in=>DAMS)
    map.collection(:in => DAMS)
    map.assembledCollection(:in => DAMS)
    map.provenanceCollection(:in => DAMS)
    map.provenanceCollectionPart(:in => DAMS)
 end
  
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.ProvenanceCollectionPart]) if new?
    super
  end

 
  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'type', 'Collection')   
    Solrizer.insert_field(solr_doc, 'type', 'ProvenanceCollectionPart')
	super
  end
end
