class DamsObjectDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.resource_type(:in => DAMS, :to => 'typeOfResource')
    map.title_node(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.collection(:in => DAMS)#, :class_name => 'AssembledCollection')
    map.subject_node(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
    map.odate(:in => DAMS, :to=>'date', :class_name => 'Date')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.unit_node(:in => DAMS, :to=>'unit')
    map.copyright(:in=>DAMS)
    map.license(:in=>DAMS)
    map.otherRights(:in=>DAMS)
    map.statute(:in=>DAMS)
    map.language(:in=>DAMS)
    map.rightsHolder(:in=>DAMS)
    map.note_node(:in => DAMS, :to=>'note', :class_name => 'Note')
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.component(:in => DAMS, :to=>'hasComponent', :class_name => 'Component')
    map.file(:in => DAMS, :to=>'hasFile', :class_name => 'File')
 end

# DAMS Object links/properties from data dictionary
#
# not mapped:
#     Collection (collection 0-m) bb03030303
#     DAMS Event (event 1-m) bb07070707
#
#mapped:
#  in-object
#    typeOfResource
#    Component (hasComponent 0-m)
#    Date (date 0-m)
#    File (hasFile 0-m)
#    Note (note 0-m)
#    Related Resource (otherResource 0-m)
#    Relationship (relationship 0-m)
#    Subject (subject 0-m)
#    Title (title 1-m)
#  links
#     Unit (unit 1) bb02020202
#     Copyright (copyright 1) bb05050505
#     License (license, 0-1)  bb22222222
#     Other Rights (otherRights, 0-1) bb06060606
#     Statute (statute, 0-1) bb21212121
#     Language (language 1-m) bd0410344f
#     Name (rightsHolder 0-m) bb09090909

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Object]) if new?
    super
  end

  class Component
    include ActiveFedora::RdfObject
    rdf_type DAMS.Component
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
    map_predicates do |map|     
      map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
      map.resource_type(:in => DAMS, :to => 'typeOfResource')
      map.date(:in => DAMS, :to=>'date', :class_name => 'Date')
      map.note(:in => DAMS, :to=>'note', :class_name => 'Note')
      map.file(:in => DAMS, :to=>'hasFile', :class_name => 'File')
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
    end
    class File
      include ActiveFedora::RdfObject
      rdf_type DAMS.File
      map_predicates do |map|    
        map.value(:in=> RDF)
        map.crc32checksum(:in=>DAMS)
        map.formatVersion(:in=>DAMS)
        map.md5checksum(:in=>DAMS)
        map.preservationLevel(:in=>DAMS)
        map.formatName(:in=>DAMS)
        map.use(:in=>DAMS)
        map.mimeType(:in=>DAMS)
        map.objectCategory(:in=>DAMS)
        map.sha1checksum(:in=>DAMS)
        map.sourcePath(:in=>DAMS)
        map.dateCreated(:in=>DAMS)
        map.quality(:in=>DAMS)
        map.sourceFileName(:in=>DAMS)
        map.size(:in=>DAMS)
        map.compositionLevel(:in=>DAMS)
      end
    end
  end

  class Note
    include ActiveFedora::RdfObject
    rdf_type DAMS.Note
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
  end
  
  def notes
    #note_node.map{|n| "#{n.displayLabel.first}: #{n.value.first}"}
    note_node ? note_node: []
  end
  
  def notes=(val)
    self.note_node = []
    val.each do |n|
      note_node.build.value = n
    end
  end
     
  class RelatedResource
    include ActiveFedora::RdfObject
    rdf_type DAMS.RelatedResource
    map_predicates do |map|    
      map.type(:in=> DAMS)
      map.description(:in=> DAMS)
      map.uri(:in=> DAMS)
    end
  end
  class File
    include ActiveFedora::RdfObject
    rdf_type DAMS.File
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.crc32checksum(:in=>DAMS)
      map.formatVersion(:in=>DAMS)
      map.md5checksum(:in=>DAMS)
      map.preservationLevel(:in=>DAMS)
      map.formatName(:in=>DAMS)
      map.use(:in=>DAMS)
      map.mimeType(:in=>DAMS)
      map.objectCategory(:in=>DAMS)
      map.sha1checksum(:in=>DAMS)
      map.sourcePath(:in=>DAMS)
      map.dateCreated(:in=>DAMS)
      map.quality(:in=>DAMS)
      map.sourceFileName(:in=>DAMS)
      map.size(:in=>DAMS)
      map.compositionLevel(:in=>DAMS)
    end
  end
  class Title
    include ActiveFedora::RdfObject
    rdf_type DAMS.Title
    map_predicates do |map|   
      map.value(:in=> RDF)
      map.subtitle(:in=> DAMS)
      map.type(:in=> DAMS)
    end
  end
  def title
    title_node.first ? title_node.first.value : []
  end
  def title=(val)
    self.title_node = []
    title_node.build.value = val
  end

  def subtitle
    self.title_node.first ? self.title_node.first.subtitle : [] 
  end
  def subtitle=(val)
    if self.title_node == nil
      self.title_node = []
    end
    self.title_node.build.subtitle = val
  end

  # see app/models/dams_assembled_collection.rb
  #class AssembledCollection
  #  include ActiveFedora::RdfObject
  #  map_predicates do |map|
  #    rdf_type DAMS.AssembledCollection
  #    map.scopeContentNote(:in=> DAMS, :class_name=>'ScopeContentNote') 
  #  end
  #  class ScopeContentNote
  #    include ActiveFedora::RdfObject
  #    map_predicates do |map|
  #      rdf_type DAMS.ScopeContentNote
  #      map.displayLabel(:in=> DAMS)
  #    end
  #  end
  #end

  class Date
    include ActiveFedora::RdfObject
    rdf_type DAMS.Date
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.beginDate(:in=>DAMS)
      map.endDate(:in=>DAMS)
    end
  end
  def date
    odate.first ? odate.first.value : []
  end
  def date=(val)
    self.odate = []
    odate.build.value = val
  end
  def beginDate
    odate.first ? odate.first.beginDate : []
  end
  def beginDate=(val)
    self.odate = []
    odate.build.beginDate = val
  end
  def endDate
    odate.first ? odate.first.endDate : []
  end
  def endDate=(val)
    self.odate = []
    odate.build.endDate = val
  end

  class Subject
    include ActiveFedora::RdfObject
    rdf_type MADS.ComplexSubject
    map_predicates do |map|      
      map.authoritativeLabel(:in=> MADS)
    end

    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      md = /\/(\w*)$/.match(uri)
      DamsSubject.find(md[1])
    end
  end
  def subject
    subject_node.map{|s| s.authoritativeLabel.first}
  end
  def subject=(val)
    self.subject_node = []
    val.each do |s|
      subject_node.build.authoritativeLabel = s
    end
  end

  class Relationship
    include ActiveFedora::RdfObject
    rdf_type DAMS.Relationship
    map_predicates do |map|     
      map.name(:in=> DAMS)
      map.role(:in=> DAMS)
    end

    def load
      uri = name.first.to_s
      md = /\/(\w*)$/.match(uri)
      DamsPerson.find(md[1])
    end
  end

  def load_unit
    unit_uri = unit_node.values.first.to_s
    unit_pid = unit_uri.gsub(/.*\//,'')
    if unit_pid != nil && unit_pid != ""
      DamsUnit.find(unit_pid)
    else
      nil
    end
  end
  def load_collection
    collection_uri = collection.values.first.to_s
    collection_pid = collection_uri.gsub(/.*\//,'')
    if collection_pid != nil && collection_pid != ""
      DamsAssembledCollection.find(collection_pid) 
    elsif(collection_pid != nil && collection_pid != "" && DamsAssembledCollection.find(collection_pid).nil?)
      	DamsProvenanceCollection.find(collection_pid)
    else
      nil
    end
  end
  def load_copyright
    c_uri = copyright.values.first.to_s
    c_pid = c_uri.gsub(/.*\//,'')
    if c_pid != nil && c_pid != ""
      DamsCopyright.find(c_pid)
    end
  end
  def load_license
    l_uri = license.values.first.to_s
    l_pid = l_uri.gsub(/.*\//,'')
    if l_pid != nil && l_pid != ""
      DamsLicense.find(l_pid)
    end
  end
  def load_statute
    s_uri = statute.values.first.to_s
    s_pid = s_uri.gsub(/.*\//,'')
    if s_pid != nil && s_pid != ""
      DamsStatute.find(s_pid)
    end
  end
  def load_otherRights
    o_uri = otherRights.values.first.to_s
    o_pid = o_uri.gsub(/.*\//,'')
    if o_pid != nil && o_pid != ""
      DamsOtherRights.find(o_pid)
    end
  end
  def load_languages
    languages = []
    language.values.each do |lang|
      lang_uri = lang.to_s
      lang_pid = lang_uri.gsub(/.*\//,'')
      if lang_pid != nil && lang_pid != ""
        languages << DamsLanguage.find(lang_pid)
      end
    end
    languages
  end
  def load_rightsHolders
    rightsHolders = []
    rightsHolder.values.each do |name|
      name_uri = name.to_s
      name_pid = name_uri.gsub(/.*\//,'')
      if name_pid != nil && name_pid != ""
        rightsHolders << DamsPerson.find(name_pid)
      end
    end
    rightsHolders
  end

  def to_solr (solr_doc = {})

    # field types
    storedInt = Solrizer::Descriptor.new(:integer, :indexed, :stored)

    subject_node.map do |sn| 
      subject_value = sn.external? ? sn.load.name : sn.authoritativeLabel
      Solrizer.insert_field(solr_doc, 'subject', subject_value)
    end
    Solrizer.insert_field(solr_doc, 'title', title)
    Solrizer.insert_field(solr_doc, 'date', date)
    
    relationship.map do |relationship| 
      Solrizer.insert_field(solr_doc, 'name', relationship.load.name )
    end
    Solrizer.insert_field(solr_doc, "resource_type", resource_type.first)

    copy = load_copyright
    if copy != nil
      Solrizer.insert_field(solr_doc, 'copyright_status', copy.status)
      Solrizer.insert_field(solr_doc, 'copyright_jurisdiction', copy.jurisdiction)
      Solrizer.insert_field(solr_doc, 'copyright_purposeNote', copy.purposeNote)
      Solrizer.insert_field(solr_doc, 'copyright_note', copy.note)
      Solrizer.insert_field(solr_doc, 'copyright_beginDate', copy.beginDate)
      Solrizer.insert_field(solr_doc, 'copyright_id', copy.pid)
    end

    lic = load_license
    if lic != nil
      Solrizer.insert_field(solr_doc, 'license_id', lic.pid)
      Solrizer.insert_field(solr_doc, 'license_note', lic.note)
      Solrizer.insert_field(solr_doc, 'license_uri', lic.uri.values.first.to_s)
      Solrizer.insert_field(solr_doc, 'license_permissionType', lic.permissionType)
      Solrizer.insert_field(solr_doc, 'license_permissionBeginDate', lic.permissionBeginDate)
      Solrizer.insert_field(solr_doc, 'license_permissionEndDate', lic.permissionEndDate)
      Solrizer.insert_field(solr_doc, 'license_restrictionType', lic.restrictionType)
      Solrizer.insert_field(solr_doc, 'license_restrictionBeginDate', lic.restrictionBeginDate)
      Solrizer.insert_field(solr_doc, 'license_restrictionEndDate', lic.restrictionEndDate)
    end

    stat = load_statute
    if stat != nil
      Solrizer.insert_field(solr_doc, 'statute_id', stat.pid)
      Solrizer.insert_field(solr_doc, 'statute_citation', stat.citation)
      Solrizer.insert_field(solr_doc, 'statute_jurisdiction', stat.jurisdiction)
      Solrizer.insert_field(solr_doc, 'statute_note', stat.note)
      Solrizer.insert_field(solr_doc, 'statute_permissionType', stat.permissionType)
      Solrizer.insert_field(solr_doc, 'statute_permissionBeginDate', stat.permissionBeginDate)
      Solrizer.insert_field(solr_doc, 'statute_permissionEndDate', stat.permissionEndDate)
      Solrizer.insert_field(solr_doc, 'statute_restrictionType', stat.restrictionType)
      Solrizer.insert_field(solr_doc, 'statute_restrictionBeginDate', stat.restrictionBeginDate)
      Solrizer.insert_field(solr_doc, 'statute_restrictionEndDate', stat.restrictionEndDate)
    end

    othr = load_otherRights
    if othr != nil
      Solrizer.insert_field(solr_doc, 'otherRights_id', othr.pid)
      Solrizer.insert_field(solr_doc, 'otherRights_basis', othr.basis)
      Solrizer.insert_field(solr_doc, 'otherRights_note', othr.note)
      Solrizer.insert_field(solr_doc, 'otherRights_uri', othr.uri.first.to_s)
      Solrizer.insert_field(solr_doc, 'otherRights_permissionType', othr.permissionType)
      Solrizer.insert_field(solr_doc, 'otherRights_permissionBeginDate', othr.permissionBeginDate)
      Solrizer.insert_field(solr_doc, 'otherRights_permissionEndDate', othr.permissionEndDate)
      Solrizer.insert_field(solr_doc, 'otherRights_restrictionType', othr.restrictionType)
      Solrizer.insert_field(solr_doc, 'otherRights_restrictionBeginDate', othr.restrictionBeginDate)
      Solrizer.insert_field(solr_doc, 'otherRights_restrictionEndDate', othr.restrictionEndDate)
      Solrizer.insert_field(solr_doc, 'otherRights_name', othr.name.first.to_s)
      Solrizer.insert_field(solr_doc, 'otherRights_role', othr.role.first.to_s)
    end

    langs = load_languages
    if langs != nil
      n = 0
      langs.each do |lang|
        n += 1
        Solrizer.insert_field(solr_doc, "language_#{n}_id", lang.pid)
        Solrizer.insert_field(solr_doc, "language_#{n}_code", lang.code)
        Solrizer.insert_field(solr_doc, "language_#{n}_value", lang.value)
        Solrizer.insert_field(solr_doc, "language_#{n}_valueURI", lang.valueURI.first.to_s)
      end
    end
    
   # notes = load_notes
    #if notes != nil
     # n = 0
     # notes.each do |note|
     #   n += 1
     #   Solrizer.insert_field(solr_doc, "note_#{n}_displayLabel", note.displayLabel)
     #   Solrizer.insert_field(solr_doc, "note_#{n}_type", note.type)
     #   Solrizer.insert_field(solr_doc, "note_#{n}_value", lang.value)       
     # end
    #end
    
    rightsHolders = load_rightsHolders
    if rightsHolders != nil
      n = 0
      rightsHolders.each do |name|
        if name.class == DamsPerson
          n += 1
          Solrizer.insert_field(solr_doc, "rightsHolder_#{n}_id", name.pid)
          Solrizer.insert_field(solr_doc, "rightsHolder_#{n}_name", name.name)
        end
      end
    end

    unit = load_unit
    if unit.class == DamsUnit
      Solrizer.insert_field(solr_doc, 'unit_name', unit.name)
      Solrizer.insert_field(solr_doc, 'unit_id', unit.pid)
    end

    col = load_collection
    if col.class == DamsAssembledCollection
      Solrizer.insert_field(solr_doc, 'collection_name', col.title.first.value)
      Solrizer.insert_field(solr_doc, 'collection_id', col.pid)
    elsif col.class == DamsProvenanceCollection
      Solrizer.insert_field(solr_doc, 'collection_name', col.title.first.value)
      Solrizer.insert_field(solr_doc, 'collection_id', col.pid)
    end
    
    # component metadata
    if component != nil && component.count > 0
      Solrizer.insert_field(solr_doc, "component_count", component.count, storedInt )
    end
    component.map do |component|
      cid = component.rdf_subject.to_s
      cid = cid.match('\w+$')
      Solrizer.insert_field(solr_doc, "component_#{cid}_title", component.title.first.value)
      Solrizer.insert_field(solr_doc, "component_#{cid}_resource_type", component.resource_type.first)
      Solrizer.insert_field(solr_doc, "component_#{cid}_date",  component.date.first.value)
      if component.note.first != nil
        Solrizer.insert_field(solr_doc, "component_#{cid}_note",  component.note.first.value)
      end
      component.file.map do |file|
        fid = file.rdf_subject.to_s
        fid = fid.gsub(/.*\//,'')
        Solrizer.insert_field(solr_doc, "component_#{cid}_files", fid)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_size",  file.size, storedInt)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_sourcePath", file.sourcePath)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_sourceFileName", file.sourceFileName)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_formatName", file.formatName)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_mimeType", file.mimeType)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_use", file.use)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_dateCreated", file.dateCreated)
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_quality", file.quality)
      end
    end
    file.map do |file|
      fid = file.rdf_subject.to_s
      fid = fid.gsub(/.*\//,'')
      Solrizer.insert_field(solr_doc, "files", fid)
      Solrizer.insert_field(solr_doc, "file_#{fid}_size",  file.size, storedInt)
      Solrizer.insert_field(solr_doc, "file_#{fid}_sourcePath", file.sourcePath)
      Solrizer.insert_field(solr_doc, "file_#{fid}_sourceFileName", file.sourceFileName)
      Solrizer.insert_field(solr_doc, "file_#{fid}_formatName", file.formatName)
      Solrizer.insert_field(solr_doc, "file_#{fid}_mimeType", file.mimeType)
      Solrizer.insert_field(solr_doc, "file_#{fid}_use", file.use)
      Solrizer.insert_field(solr_doc, "file_#{fid}_dateCreated", file.dateCreated)
      Solrizer.insert_field(solr_doc, "file_#{fid}_quality", file.quality)
    end
    n = 0
    relatedResource.map do |resource|
      n += 1
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_type", resource.type)
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_uri", resource.uri)
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_description", resource.description)
    end
	n = 0
    note_node.map do |no|
      n += 1
      Solrizer.insert_field(solr_doc, "note_#{n}_type", no.type)
      Solrizer.insert_field(solr_doc, "note_#{n}_displayLabel", no.displayLabel)
      Solrizer.insert_field(solr_doc, "note_#{n}_value", no.value)
    end
    
    # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }
    return solr_doc
  end
end

