class Component
    include ActiveFedora::RdfObject
    rdf_type DAMS.Component
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
    map_predicates do |map|
      map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
      map.date(:in => DAMS, :to=>'date', :class_name => 'Date')
      map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
      map.language(:in=>DAMS, :class_name => 'DamsLanguageInternal')

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

      # related resources
      map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')

      # components and files
      map.subcomponent(:in=>DAMS, :to=>'hasComponent', :class => Component)
      map.file(:in => DAMS, :to=>'hasFile', :class_name => 'DamsFile')

      # rights
      map.copyright(:in=>DAMS,:class_name => 'DamsCopyrightInternal')
      map.license(:in=>DAMS,:class_name => 'DamsLicenseInternal')
      map.otherRights(:in=>DAMS)
      map.statute(:in=>DAMS)
      map.rightsHolder(:in=>DAMS,:class_name => 'DamsRightsHolderInternal')

      # resource type and cartographics
      map.resource_type(:in => DAMS, :to => 'typeOfResource')
      map.cartographics(:in => DAMS, :class_name => 'Cartographics')
    end

    def id
      cid = rdf_subject.to_s
      cid = cid.match('\w+$').to_s
      cid.to_i
    end
    class Date
      include ActiveFedora::RdfObject
      rdf_type DAMS.Date
      map_predicates do |map|
        map.value(:in=> RDF, :to=>'value')
        map.beginDate(:in=>DAMS, :to=>'beginDate')
        map.endDate(:in=>DAMS, :to=>'endDate')
      end
    end
#    class File
#      include ActiveFedora::RdfObject
#      rdf_type DAMS.File
#      map_predicates do |map|
#        map.filestore(:in=>DAMS)
#        map.quality(:in=>DAMS)
#        map.size(:in=>DAMS)
#        map.sourceFileName(:in=>DAMS)
#        map.sourcePath(:in=>DAMS)
#        map.use(:in=>DAMS)
#        map.value(:in=> RDF)
#
#        # checksums
#        map.crc32checksum(:in=>DAMS)
#        map.md5checksum(:in=>DAMS)
#        map.sha1checksum(:in=>DAMS)
#        map.sha256checksum(:in=>DAMS)
#        map.sha512checksum(:in=>DAMS)
#
#        # premis
#        map.compositionLevel(:in=>DAMS)
#        map.dateCreated(:in=>DAMS)
#        map.formatName(:in=>DAMS)
#        map.formatVersion(:in=>DAMS)
#        map.mimeType(:in=>DAMS)
#        map.objectCategory(:in=>DAMS)
#        map.preservationLevel(:in=>DAMS)
#        map.event(:in=>DAMS)
#
#        # mix
#        map.source_capture(:in=>DAMS, :to => 'sourceCapture')
#      end
#      def id
#        fid = rdf_subject.to_s
#        fid = fid.gsub(/.*\//,'')
#        fid
#      end
#      def order
#        order = id.gsub(/\..*/,'')
#        order.to_i
#      end
#    end
end
