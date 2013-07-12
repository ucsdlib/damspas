class DamsProvenanceCollectionPartDatastream < DamsResourceDatastream
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
    map.subject(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
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
    map.event(:in=>DAMS, :class_name => 'DamsEventInternal')

    # parent collection
    map.provenanceCollection(:in => DAMS, :class_name => 'DamsProvenanceCollectionInternal')

    # related collections
    map.relatedCollection(:in => DAMS)

    # related objects
    map.object(:in => DAMS, :to => 'hasObject')
 end
  
 

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.ProvenanceCollectionPart]) if new?
    if(!@subURI.nil?)
      if new?
        @array_subject.each do |sub|
          graph.insert([rdf_subject, DAMS.subject, sub])
        end
        #graph.insert([rdf_subject, DAMS.subject, @subURI])
      else
        graph.update([rdf_subject, DAMS.subject, @subURI])
      end
    end  
    if(!@langURI.nil?)
      if new?
        graph.insert([rdf_subject, DAMS.language, @langURI])
      else
        graph.update([rdf_subject, DAMS.language, @langURI])
      end
    end   
    if(!@damsObjURI.nil?)
      if new?
        graph.insert([rdf_subject, DAMS.object, @damsObjURI])
      else
        graph.update([rdf_subject, DAMS.object, @damsObjURI])
      end
    end  
    if(!@provenanceCollURI.nil?)
      if new?
        graph.insert([rdf_subject, DAMS.provenanceCollection, @provenanceCollURI])
      else
        graph.update([rdf_subject, DAMS.provenanceCollection, @provenanceCollURI])
      end
    end   
    super
  end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
 
  def to_solr (solr_doc = {})
    Solrizer.insert_field(solr_doc, 'type', 'Collection')   
    Solrizer.insert_field(solr_doc, 'type', 'ProvenanceCollectionPart')
	super
  end
end
