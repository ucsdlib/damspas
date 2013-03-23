class DamsObjectDatastream < DamsResourceDatastream
  map_predicates do |map|
    map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.date(:in => DAMS, :to=>'date', :class_name => 'Date')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.language(:in=>DAMS, :class_name => 'Language')
    #map.language(:in=>DAMS)

    # notes
    map.note(:in => DAMS, :to=>'note', :class_name => 'Note')
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'CustodialResponsibilityNote')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'PreferredCitationNote')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'ScopeContentNote')

    # subjects
    map.subject(:in => DAMS, :to=> 'subject', :class_name => 'Subject')
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

    # unit and collections
    map.unit_node(:in => DAMS, :to=>'unit')
    map.collection(:in => DAMS)
    map.assembledCollection(:in => DAMS)
    map.provenanceCollection(:in => DAMS)
    map.provenanceCollectionPart(:in => DAMS)

    # components and files
    map.component(:in => DAMS, :to=>'hasComponent', :class_name => 'Component')
    map.file(:in => DAMS, :to=>'hasFile', :class_name => 'DamsFile')

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
 
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Object]) if new?
    super
  end

#  class File
#    include ActiveFedora::RdfObject
#    rdf_type DAMS.File
#    map_predicates do |map|
#      map.filestore(:in=>DAMS)
#      map.quality(:in=>DAMS)
#      map.size(:in=>DAMS)
#      map.sourceFileName(:in=>DAMS)
#      map.sourcePath(:in=>DAMS)
#      map.use(:in=>DAMS)
#      map.value(:in=> RDF)
#
#      # checksums
#      map.crc32checksum(:in=>DAMS)
#      map.md5checksum(:in=>DAMS)
#      map.sha1checksum(:in=>DAMS)
#      map.sha256checksum(:in=>DAMS)
#      map.sha512checksum(:in=>DAMS)
#
#      # premis
#      map.compositionLevel(:in=>DAMS)
#      map.dateCreated(:in=>DAMS)
#      map.formatName(:in=>DAMS)
#      map.formatVersion(:in=>DAMS)
#      map.mimeType(:in=>DAMS)
#      map.objectCategory(:in=>DAMS)
#      map.preservationLevel(:in=>DAMS)
#      map.event(:in=>DAMS)
#
#      # mix
#      map.source_capture(:in=>DAMS, :to => 'sourceCapture')
#    end
#    def id
#      fid = rdf_subject.to_s
#      fid = fid.gsub(/.*\//,'')
#      fid
#    end
#    def order
#      order = id.gsub(/\..*/,'')
#      order.to_i
#    end
#  end

  def load_unit
    load_unit(unit)
  end
  def load_unit(unit)
    unit_uri = unit.values.first.to_s
    unit_pid = unit_uri.gsub(/.*\//,'')
    if unit_pid != nil && unit_pid != ""
      DamsUnit.find(unit_pid)
    else
      nil
    end
  end

  def load_collection
    load_collection(collection,assembledCollection,provenanceCollection,provenanceCollectionPart)
  end
  def load_collection (collection,assembledCollection,provenanceCollection,provenanceCollectionPart)
    collections = []
    [collection,assembledCollection,provenanceCollection,provenanceCollectionPart].each do |coltype|
      coltype.values.each do |col|
        collection_uri = col.to_s
	    collection_pid = collection_uri.gsub(/.*\//,'')
	    hasModel = "";
        if (collection_pid != nil && collection_pid != "")
           obj = DamsAssembledCollection.find(collection_pid)
      	   hasModel = obj.relationships(:has_model).to_s
        end
	    if (!obj.nil? && !hasModel.nil? && (hasModel.include? 'Assembled'))
      		  collections << obj
        elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'ProvenanceCollectionPart'))
      		  collections << DamsProvenanceCollectionPart.find(collection_pid)
        elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'ProvenanceCollection'))
      		  collections << DamsProvenanceCollection.find(collection_pid)
        end
      end
   	
    end
    collections
  end
  
    def load_copyright
    load_copyright( copyright )
  end
  def load_copyright ( copyright )
    c_uri = copyright.values.first.to_s
    c_pid = c_uri.gsub(/.*\//,'')
    if c_pid != nil && c_pid != ""
      DamsCopyright.find(c_pid)
    end
  end
  def load_license
    load_copyright(license)
  end
  def load_license (license)
    l_uri = license.values.first.to_s
    l_pid = l_uri.gsub(/.*\//,'')
    if l_pid != nil && l_pid != ""
      DamsLicense.find(l_pid)
    end
  end
  def load_statute
    load_statute(statute)
  end
  def load_statute (statute)
    s_uri = statute.values.first.to_s
    s_pid = s_uri.gsub(/.*\//,'')
    if s_pid != nil && s_pid != ""
      DamsStatute.find(s_pid)
    end
  end
  def load_otherRights
    load_otherRights(otherRights)
  end
  def load_otherRights (otherRights)
    o_uri = otherRights.values.first.to_s
    o_pid = o_uri.gsub(/.*\//,'')
    if o_pid != nil && o_pid != ""
      DamsOtherRights.find(o_pid)
    end
  end

  def load_source_capture(source_capture)
    uri = source_capture.values.first.to_s
    pid = uri.gsub(/.*\//,'')
    if pid != nil && pid != ""
      obj = DamsSourceCapture.find(pid)
      obj
    else
      nil
    end
  end

  def load_rightsHolders
    load_rightsHolders(rightsHolder)
  end
  def load_rightsHolders(rightsHolder)
    rightsHolders = []
    rightsHolder.values.each do |name|
      name_uri = name.to_s
      name_pid = name_uri.gsub(/.*\//,'')
      if name_pid != nil && name_pid != ""
        rightsHolders << MadsPersonalName.find(name_pid)
      end
    end
    rightsHolders
  end

  def insertFileFields( solr_doc, cid, files )
    singleString = Solrizer::Descriptor.new(:string, :indexed, :stored)
    prefix = (cid != nil) ? "component_#{cid}_" : ""
    altprefix = (cid != nil) ? "file_#{cid}" : "file"
    files.map.sort{ |a,b| a.order <=> b.order }.each { |file|
      fid = file.id
      Solrizer.insert_field(solr_doc, "#{altprefix}_#{fid}_filestore", file.filestore)
      Solrizer.insert_field(solr_doc, "#{prefix}files", fid)
      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_quality", file.quality)
      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_size", file.size, singleString)
      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_sourcePath", file.sourcePath)
      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_sourceFileName", file.sourceFileName)
      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_use", file.use)
      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_label", file.value)

      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_dateCreated", file.dateCreated)
      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_formatName", file.formatName)
      Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_mimeType", file.mimeType)

      source_capture = load_source_capture file.source_capture
      if source_capture.class == DamsSourceCapture
        Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_source_capture", source_capture.pid)
        Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_capture_source", source_capture.captureSource)
        Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_image_producer", source_capture.imageProducer)
        Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_scanner_manufacturer", source_capture.scannerManufacturer)
        Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_scanner_model_name", source_capture.scannerModelName)
        Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_scanning_software", source_capture.scanningSoftware)
        Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_scanning_software_version", source_capture.scanningSoftwareVersion)
        Solrizer.insert_field(solr_doc, "#{prefix}file_#{fid}_source_type", source_capture.sourceType)
      end

      insertEventFields solr_doc, "#{prefix}file_#{fid}_", file.event
    }
  end
  def insertCopyrightFields ( solr_doc, prefix, copyright )
    copy = load_copyright copyright
    if copy != nil
      Solrizer.insert_field(solr_doc, "#{prefix}copyright_status", copy.status)
      Solrizer.insert_field(solr_doc, "#{prefix}copyright_jurisdiction", copy.jurisdiction)
      Solrizer.insert_field(solr_doc, "#{prefix}copyright_purposeNote", copy.purposeNote)
      Solrizer.insert_field(solr_doc, "#{prefix}copyright_note", copy.note)
      Solrizer.insert_field(solr_doc, "#{prefix}copyright_beginDate", copy.beginDate)
      Solrizer.insert_field(solr_doc, "#{prefix}copyright_id", copy.pid)
    end
  end
  def insertLicenseFields( solr_doc, prefix, license )
    lic = load_license license
    if lic != nil
      Solrizer.insert_field(solr_doc, "#{prefix}license_id", lic.pid)
      Solrizer.insert_field(solr_doc, "#{prefix}license_note", lic.note)
      Solrizer.insert_field(solr_doc, "#{prefix}license_uri", lic.uri.values.first.to_s)
      Solrizer.insert_field(solr_doc, "#{prefix}license_permissionType", lic.permissionType)
      Solrizer.insert_field(solr_doc, "#{prefix}license_permissionBeginDate", lic.permissionBeginDate)
      Solrizer.insert_field(solr_doc, "#{prefix}license_permissionEndDate", lic.permissionEndDate)
      Solrizer.insert_field(solr_doc, "#{prefix}license_restrictionType", lic.restrictionType)
      Solrizer.insert_field(solr_doc, "#{prefix}license_restrictionBeginDate", lic.restrictionBeginDate)
      Solrizer.insert_field(solr_doc, "#{prefix}license_restrictionEndDate", lic.restrictionEndDate)
    end
  end
  def insertStatuteFields( solr_doc, prefix, statute )
    stat = load_statute statute
    if stat != nil
      Solrizer.insert_field(solr_doc, "#{prefix}statute_id", stat.pid)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_citation", stat.citation)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_jurisdiction", stat.jurisdiction)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_note", stat.note)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_permissionType", stat.permissionType)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_permissionBeginDate", stat.permissionBeginDate)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_permissionEndDate", stat.permissionEndDate)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_restrictionType", stat.restrictionType)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_restrictionBeginDate", stat.restrictionBeginDate)
      Solrizer.insert_field(solr_doc, "#{prefix}statute_restrictionEndDate", stat.restrictionEndDate)
    end
  end
  def insertOtherRightsFields( solr_doc, prefix, otherRights )
    othr = load_otherRights otherRights
    if othr != nil
      Solrizer.insert_field(solr_doc, "otherRights_id", othr.pid)
      Solrizer.insert_field(solr_doc, "otherRights_basis", othr.basis)
      Solrizer.insert_field(solr_doc, "otherRights_note", othr.note)
      Solrizer.insert_field(solr_doc, "otherRights_uri", othr.uri.first.to_s)
      Solrizer.insert_field(solr_doc, "otherRights_permissionType", othr.permissionType)
      Solrizer.insert_field(solr_doc, "otherRights_permissionBeginDate", othr.permissionBeginDate)
      Solrizer.insert_field(solr_doc, "otherRights_permissionEndDate", othr.permissionEndDate)
      Solrizer.insert_field(solr_doc, "otherRights_restrictionType", othr.restrictionType)
      Solrizer.insert_field(solr_doc, "otherRights_restrictionBeginDate", othr.restrictionBeginDate)
      Solrizer.insert_field(solr_doc, "otherRights_restrictionEndDate", othr.restrictionEndDate)
      Solrizer.insert_field(solr_doc, "otherRights_name", othr.name.first.to_s)
      Solrizer.insert_field(solr_doc, "otherRights_role", othr.role.first.to_s)
    end    
  end
  def insertRightsHolderFields( solr_doc, prefix, rightsHolder )
    rightsHolders = load_rightsHolders rightsHolder
    if rightsHolders != nil
      n = 0
      rightsHolders.each do |name|
        if name.class == MadsPersonalName
          n += 1
          Solrizer.insert_field(solr_doc, "#{prefix}rightsHolder_#{n}_id", name.pid)
          Solrizer.insert_field(solr_doc, "#{prefix}rightsHolder_#{n}_name", name.name)
        end
      end
    end
  end
          
  def to_solr (solr_doc = {})
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    singleString = Solrizer::Descriptor.new(:string, :indexed, :stored)
    storedInt = Solrizer::Descriptor.new(:integer, :indexed, :stored)
    storedIntMulti = Solrizer::Descriptor.new(:integer, :indexed, :stored, :multivalued)
    
    # component metadata
    @parents = Hash.new
    @children = Array.new
    if component != nil && component.count > 0
      Solrizer.insert_field(solr_doc, "component_count", component.count, storedInt )
    end
    component.map.sort{ |a,b| a.id <=> b.id }.each { |component|
      cid = component.id
      @parents[cid] = Array.new

      # child components
      component.subcomponent.map.sort.each { |subcomponent|
        subid = /\/(\w*)$/.match(subcomponent.to_s)
        gid = subid[1].to_i
        @children << gid
        Solrizer.insert_field(solr_doc, "component_#{cid}_children", gid, storedIntMulti)
        @parents[cid] << gid
      }

      # titles
      insertTitleFields solr_doc, cid, component.title

      Solrizer.insert_field(solr_doc, "component_#{cid}_resource_type", component.resource_type.first)

      insertDateFields solr_doc, cid, component.date
      insertRelationshipFields solr_doc, "component_#{cid}_", component.relationship
      insertLanguageFields solr_doc, "component_#{cid}_", component.language

      insertNoteFields solr_doc, "component_#{cid}_note",component.note
      insertNoteFields solr_doc, "component_#{cid}_custodialResponsibilityNote",component.custodialResponsibilityNote
      insertNoteFields solr_doc, "component_#{cid}_preferredCitationNote",component.preferredCitationNote
      insertNoteFields solr_doc, "component_#{cid}_scopeContentNote",component.scopeContentNote

      insertComplexSubjectFields solr_doc, "component_#{cid}_complexSubject", load_complexSubjects(component.complexSubject)
      insertFields solr_doc, "component_#{cid}_builtWorkPlace", load_builtWorkPlaces(component.builtWorkPlace)
      insertFields solr_doc, "component_#{cid}_culturalContext", load_culturalContexts(component.culturalContext)
      insertFields solr_doc, "component_#{cid}_function", load_functions(component.function)
      insertFields solr_doc, "component_#{cid}_genreForm", load_genreForms(component.genreForm)
      insertFields solr_doc, "component_#{cid}_geographic", load_geographics(component.geographic)
      insertFields solr_doc, "component_#{cid}_iconography", load_iconographies(component.iconography)
      insertFields solr_doc, "component_#{cid}_occupation", load_occupations(component.occupation)
      insertFields solr_doc, "component_#{cid}_scientificName", load_scientificNames(component.scientificName)
      insertFields solr_doc, "component_#{cid}_stylePeriod", load_stylePeriods(component.stylePeriod)
      insertFields solr_doc, "component_#{cid}_technique", load_techniques(component.technique)
      insertFields solr_doc, "component_#{cid}_temporal", load_temporals(component.temporal)
      insertFields solr_doc, "component_#{cid}_topic", load_topics(component.topic)

      insertFields solr_doc, "component_#{cid}_name", load_names(component.name)
      insertFields solr_doc, "component_#{cid}_conferenceName", load_conferenceNames(component.conferenceName)
      insertFields solr_doc, "component_#{cid}_corporateName", load_corporateNames(component.corporateName)
      insertFields solr_doc, "component_#{cid}_familyName", load_familyNames(component.familyName)
      insertFields solr_doc, "component_#{cid}_personalName", load_personalNames(component.personalName)

      insertCopyrightFields solr_doc, "component_#{cid}_", component.copyright
      insertLicenseFields solr_doc, "component_#{cid}_", component.license
      insertStatuteFields solr_doc, "component_#{cid}_", component.statute
      insertOtherRightsFields solr_doc, "component_#{cid}_", component.otherRights

      insertFileFields solr_doc, cid, component.file
    }

    # build component hierarchy map
    @cmap = Hash.new
    @parents.keys.sort{|x,y| x.to_i <=> y.to_i}.each { |p|
      # only process top-level objects
      if not @children.include?(p)
        # p is a top-level component, find direct children
        @cmap[p] = find_children(p)
      end
    }
    Solrizer.insert_field(solr_doc, "component_map", @cmap.to_json)
    insertFileFields solr_doc, nil, file
    
    unit = load_unit unit_node
    if unit.class == DamsUnit
      Solrizer.insert_field(solr_doc, 'unit_code', unit.code)
      Solrizer.insert_field(solr_doc, 'unit_name', unit.name)
      Solrizer.insert_field(solr_doc, 'unit', unit.name, facetable)
      Solrizer.insert_field(solr_doc, 'unit_id', unit.pid)
    end
    
    col = load_collection collection,assembledCollection,provenanceCollection,provenanceCollectionPart
    if col != nil
     n = 0
      col.each do |collection|
        n += 1
        Solrizer.insert_field(solr_doc, "collections", collection.pid)
        Solrizer.insert_field(solr_doc, "collection_#{n}_id", collection.pid)
        Solrizer.insert_field(solr_doc, "collection_#{n}_name", collection.titleValue)
        Solrizer.insert_field(solr_doc, "collection", collection.titleValue, facetable)
        if ( collection.kind_of? DamsAssembledCollection )
          Solrizer.insert_field(solr_doc, "collection_#{n}_type", "AssembledCollection")
        elsif ( collection.kind_of? DamsProvenanceCollectionPart )
          Solrizer.insert_field(solr_doc, "collection_#{n}_type", "ProvenanceCollectionPart")
        elsif ( collection.kind_of? DamsProvenanceCollection )
          Solrizer.insert_field(solr_doc, "collection_#{n}_type", "ProvenanceCollection")
        end
      end
    end

    insertCopyrightFields solr_doc, "", copyright
    insertLicenseFields solr_doc, "", license
    insertStatuteFields solr_doc, "", statute
    insertOtherRightsFields solr_doc, "", otherRights
    insertRightsHolderFields solr_doc, "", rightsHolder
    
    cartographics.map do |cart|
      Solrizer.insert_field(solr_doc, "cartographics_point", cart.point)
      Solrizer.insert_field(solr_doc, "cartographics_line", cart.line)
      Solrizer.insert_field(solr_doc, "cartographics_polygon", cart.polygon)
      Solrizer.insert_field(solr_doc, "cartographics_projection", cart.projection)
      Solrizer.insert_field(solr_doc, "cartographics_referenceSystem", cart.referenceSystem)
      Solrizer.insert_field(solr_doc, "cartographics_scale", cart.scale)
    end 
    Solrizer.insert_field(solr_doc, "resource_type", resource_type.first)
    Solrizer.insert_field(solr_doc, "object_type", resource_type.first,facetable)    

    Solrizer.insert_field(solr_doc, "rdfxml", self.content, singleString)

	super
  end  
  
end

