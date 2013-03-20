class Component
    include ActiveFedora::RdfObject
    rdf_type DAMS.Component
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
    map_predicates do |map|
      map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
      map.date(:in => DAMS, :to=>'date', :class_name => 'Date')
      map.relationship(:in => DAMS, :class_name => 'Relationship')
      map.language(:in=>DAMS)

      # notes
      map.note(:in => DAMS, :to=>'note', :class_name => 'Note')
      map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'ScopeContentNote')
      map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'PreferredCitationNote')
      map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'CustodialResponsibilityNote')

      # subjects
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

      # related resources
      map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')

      # components and files
      map.subcomponent(:in=>DAMS, :to=>'hasComponent', :class => Component)
      map.file(:in => DAMS, :to=>'hasFile', :class_name => 'File')

      # rights
      map.copyright(:in=>DAMS)
      map.license(:in=>DAMS)
      map.otherRights(:in=>DAMS)
      map.statute(:in=>DAMS)
      map.rightsHolder(:in=>DAMS)

      # resource type and cartographics
      map.resource_type(:in => DAMS, :to => 'typeOfResource')
      map.cartographics(:in => DAMS, :class_name => 'Cartographics')
    end

    def id
      cid = rdf_subject.to_s
      cid = cid.match('\w+$').to_s
      cid.to_i
    end
    class Title
      include ActiveFedora::RdfObject
      rdf_type DAMS.Title
      map_predicates do |map|
        map.value(:in=> RDF)
        map.subtitle(:in=> DAMS, :to=>'subtitle')
        map.type(:in=> DAMS, :to=>'type')
      end
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
    class Note
      include ActiveFedora::RdfObject
      rdf_type DAMS.Note
      map_predicates do |map|
        map.value(:in=> RDF, :to=>'value')
        map.displayLabel(:in=>DAMS, :to=>'displayLabel')
        map.type(:in=>DAMS, :to=>'type')
      end
      def external?
        rdf_subject.to_s.include? Rails.configuration.id_namespace
      end
      def load
        uri = rdf_subject.to_s
        if uri.start_with?(Rails.configuration.id_namespace)
          md = /\/(\w*)$/.match(uri)
          DamsNote.find(md[1])
        end
      end
    end
    class File
      include ActiveFedora::RdfObject
      rdf_type DAMS.File
      map_predicates do |map|
        map.filestore(:in=>DAMS)
        map.quality(:in=>DAMS)
        map.size(:in=>DAMS)
        map.sourceFileName(:in=>DAMS)
        map.sourcePath(:in=>DAMS)
        map.use(:in=>DAMS)
        map.value(:in=> RDF)

        # checksums
        map.crc32checksum(:in=>DAMS)
        map.md5checksum(:in=>DAMS)
        map.sha1checksum(:in=>DAMS)
        map.sha256checksum(:in=>DAMS)
        map.sha512checksum(:in=>DAMS)

        # premis
        map.compositionLevel(:in=>DAMS)
        map.dateCreated(:in=>DAMS)
        map.formatName(:in=>DAMS)
        map.formatVersion(:in=>DAMS)
        map.mimeType(:in=>DAMS)
        map.objectCategory(:in=>DAMS)
        map.preservationLevel(:in=>DAMS)
        map.event(:in=>DAMS)

        # mix
        map.source_capture(:in=>DAMS, :to => 'sourceCapture')
      end
      def id
        fid = rdf_subject.to_s
        fid = fid.gsub(/.*\//,'')
        fid
      end
      def order
        order = id.gsub(/\..*/,'')
        order.to_i
      end
    end
end