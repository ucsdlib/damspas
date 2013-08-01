  class DamsFile
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
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
      map.event(:in=>DAMS, :class_name => 'DamsEventInternal')

      # mix
      map.sourceCapture(:in=>DAMS, :to => 'sourceCapture')
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

