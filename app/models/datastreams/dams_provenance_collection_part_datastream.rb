class DamsProvenanceCollectionPartDatastream < DamsResourceDatastream
  map_predicates do |map|
    map.title_node(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.odate(:in => DAMS, :to=>'date', :class_name => 'Date')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.language(:in=>DAMS)

    # notes
    map.note(:in => DAMS, :to=>'note', :class_name => 'Note')
    map.custodialResponsibilityNote(:in => DAMS, :class_name => 'CustodialResponsibilityNote')
    map.preferredCitationNote(:in => DAMS, :class_name => 'PreferredCitationNote')   
    map.scopeContentNote(:in => DAMS, :class_name => 'ScopeContentNote')

    # subjects
    map.subject_node(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
    map.complexSubject(:in => DAMS)
    map.builtWorkPlace(:in => DAMS)
    map.culturalContext(:in => DAMS)
    map.function(:in => DAMS)
    map.genreForm(:in => DAMS)
    map.geographic(:in => DAMS)
    map.iconography(:in => DAMS)
    map.occupation(:in => DAMS)
    map.scientificName(:in => DAMS)
    map.stylePeriod(:in => DAMS)
    map.technique(:in => DAMS)
    map.temporal(:in => DAMS)
    map.topic(:in => DAMS)

    # subject names
    map.name(:in => DAMS)
    map.conferenceName(:in => DAMS)
    map.corporateName(:in => DAMS)
    map.familyName(:in => DAMS)
    map.personalName(:in => DAMS)

    # related resources and events
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.event(:in=>DAMS)

    # parent collection
    map.provenanceCollection(:in => DAMS)

    # related collections
    map.relatedCollection(:in => DAMS)

    # related objects
    map.object(:in => DAMS, :to => 'hasObject')
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
