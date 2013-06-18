class DamsProvenanceCollectionPartInternal
    include ActiveFedora::RdfObject
    include DamsHelper
    rdf_type DAMS.ProvenanceCollectionPart
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
  map_predicates do |map|
    map.title(:in => DAMS, :class_name => 'MadsTitle')
    map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
    map.language(:in=>DAMS, :class_name => 'MadsLanguageInternal')

    # notes
    map.note(:in => DAMS, :to=>'note', :class_name => 'DamsNoteInternal')
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'DamsCustodialResponsibilityNoteInternal')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'DamsPreferredCitationNoteInternal')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'DamsScopeContentNoteInternal')

    # subjects
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

    # subject names
    map.name(:in => DAMS, :class_name => 'MadsNameInternal')
    map.conferenceName(:in => DAMS, :class_name => 'MadsConferenceNameInternal')
    map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')
    map.familyName(:in => DAMS, :class_name => 'MadsFamilyNameInternal')
    map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')

    # related resources and events
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.event(:in=>DAMS, :class_name => 'DamsDAMSEventInternal')

    # parent collection
    map.provenanceCollection(:in => DAMS, :class_name => 'DamsProvenanceCollectionInternal')

    # related collections
    map.relatedCollection(:in => DAMS)

    # related objects
    map.object(:in => DAMS, :to => 'hasObject')
 end
  
  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end

end
