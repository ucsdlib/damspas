class DamsProvenanceCollectionInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.ProvenanceCollection
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
    
    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
    map.language(:in=>DAMS, :class_name => 'DamsLanguageInternal')

    # notes
    map.note(:in => DAMS, :to=>'note', :class_name => 'DamsNoteInternal')
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'DamsCustodialResponsibilityNoteInternal')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'DamsPreferredCitationNoteInternal')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'DamsScopeContentNoteInternal')

    # subjects
    map.subject(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
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
    map.subject(:in => DAMS, :to=> 'subject', :class_name => 'Subject')
    map.complexSubject(:in => DAMS, :class_name => 'MadsComplexSubjectInternal')
    map.builtWorkPlace(:in => DAMS, :class_name => 'DamsBuiltWorkPlaceInternal')
    map.culturalContext(:in => DAMS, :class_name => 'DamsCulturalContextInternal')
    map.function(:in => DAMS, :class_name => 'DamsFunctionInternal')
    map.genreForm(:in => DAMS, :class_name => 'MadsGenreFormInternal')
    map.geographic(:in => DAMS, :class_name => 'MadsGeographicInternal')
    map.iconography(:in => DAMS, :class_name => 'DamsIconographyInternal')
    map.occupation(:in => DAMS, :class_name => 'MadsOccupationInternal')
    map.scientificName(:in => DAMS, :class_name => 'DamsScientificNameInternal')
    map.stylePeriod(:in => DAMS, :class_name => 'DamsStylePeriodInternal')
    map.technique(:in => DAMS, :class_name => 'DamsTechniqueInternal')
    map.temporal(:in => DAMS, :class_name => 'MadsTemporalInternal')
    map.topic(:in => DAMS, :class_name => 'MadsTopicInternal')

    # related resources and events
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.event(:in=>DAMS, :class_name => 'DamsDAMSEventInternal')

    # child parts
    map.part_node(:in=>DAMS,:to=>'hasPart')

    # related collections
    map.relatedCollection(:in => DAMS)

    # related objects
    map.object(:in => DAMS, :to => 'hasObject')
  end
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
