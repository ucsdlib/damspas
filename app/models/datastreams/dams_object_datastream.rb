class DamsObjectDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.resource_type(:in => DAMS, :to => 'typeOfResource')
    map.title_node(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.collection(:in => DAMS)#, :class_name => 'AssembledCollection')
    map.subject_node(:in => DAMS, :to=> 'subject', :class_name => 'Subject')
    map.odate(:in => DAMS, :to=>'date', :class_name => 'Date')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.unit_node(:in => DAMS, :to=>'unit')
    map.copyright(:in=>DAMS)
    map.license(:in=>DAMS)
    map.otherRights(:in=>DAMS)
    map.statute(:in=>DAMS)
    map.language(:in=>DAMS)
    map.rightsHolder(:in=>DAMS)
    #map.note_node(:in => DAMS, :to=>'note', :class_name => 'Note')
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.component(:in => DAMS, :to=>'hasComponent', :class_name => 'Component')
    map.file(:in => DAMS, :to=>'hasFile', :class_name => 'File')
    map.source_capture_node(:in=>DAMS, :to=>'sourceCapture')
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
    map.note(:in => DAMS, :to=>'note', :class_name => 'Note')    
    map.genreForm(:in => DAMS)
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'CustodialResponsibilityNote')
    map.occupation(:in => DAMS)            
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
      map.subcomponent(:in=>DAMS, :to=>'hasComponent', :class => DamsObjectDatastream::Component)
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

  class Note
    include ActiveFedora::RdfObject
    rdf_type DAMS.Note
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      md = /\/(\w*)$/.match(uri)
      DamsNote.find(md[1])
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
      MadsComplexSubject.find(md[1])
    end
  end
  
  def subject
    #subject_node.map{|s| s.authoritativeLabel.first}
    subject_node.map do |sn| 
    	subject_value = sn.external? ? sn.load.name.first : sn.authoritativeLabel.first
    end
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
      MadsPersonalName.find(md[1])
    end
  end

  class ScopeContentNote
    include ActiveFedora::RdfObject
    rdf_type DAMS.ScopeContentNote
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    
    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      md = /\/(\w*)$/.match(uri)
      DamsScopeContentNote.find(md[1])
    end
  end
 
  class PreferredCitationNote
    include ActiveFedora::RdfObject
    rdf_type DAMS.PreferredCitationNote
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    
    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      md = /\/(\w*)$/.match(uri)
      DamsPreferredCitationNote.find(md[1])
    end
  end  
  
  class CustodialResponsibilityNote
    include ActiveFedora::RdfObject
    rdf_type DAMS.CustodialResponsibilityNote
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    
    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      md = /\/(\w*)$/.match(uri)
      DamsCustodialResponsibilityNote.find(md[1])
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
    collections = []
    collection.values.each do |col|
      collection_uri = col.to_s
	  collection_pid = collection_uri.gsub(/.*\//,'')
	  hasModel = "";
      if (collection_pid != nil && collection_pid != "")      
         obj = DamsAssembledCollection.find(collection_pid)
      	 hasModel = obj.relationships(:has_model).to_s
      end
	  if (!obj.nil? && !hasModel.nil? && (hasModel.include? 'Assembled'))
      		collections << obj     
      elsif (!obj.nil? && !hasModel.nil? && (hasModel.include? 'Provenance'))
      		collections << DamsProvenanceCollection.find(collection_pid)     
      end
   	
    end
    collections
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
  def load_source_capture
    source_capture_uri = source_capture_node.values.first.to_s
    source_capture_pid = source_capture_uri.gsub(/.*\//,'')
    if source_capture_pid != nil && source_capture_pid != ""
      DamsSourceCapture.find(source_capture_pid)
    else
      nil
    end
  end 
   
  def load_rightsHolders
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
 
  def load_iconographies
    loadObjects iconography,DamsIconography
  end

  def load_scientificNames
	loadObjects scientificName,DamsScientificName
  end
    
  def load_techniques
	loadObjects technique,DamsTechnique
  end

  def load_builtWorkPlaces
	loadObjects builtWorkPlace,DamsBuiltWorkPlace
  end
 
  def load_geographics
	loadObjects geographic,MadsGeographic
  end   
  
  def load_temporals
	loadObjects temporal,MadsTemporal
  end  

  def load_culturalContexts
	loadObjects culturalContext,DamsCulturalContext
  end  

  def load_stylePeriods
	loadObjects stylePeriod,DamsStylePeriod
  end  

  def load_topics
	loadObjects topic,MadsTopic
  end  

  def load_functions
	loadObjects function,DamsFunction
  end  

  def load_genreForms
	loadObjects genreForm,MadsGenreForm
  end  

  def load_occupations
	loadObjects occupation,MadsOccupation
  end

  def load_personalNames
	loadObjects personalName,MadsPersonalName
  end
  
  def load_familyNames
	loadObjects familyName,MadsFamilyName
  end

  def load_names
	loadObjects name,MadsName
  end

  def load_conferenceNames
	loadObjects conferenceName,MadsConferenceName
  end

  def load_corporateNames
	loadObjects corporateName,MadsCorporateName
  end

  def load_complexSubjects
	loadObjects complexSubject,MadsComplexSubject
  end
                             
  # helper method for recursing over component hierarchy
  def find_children(p)
    kids = @parents[p]
    if kids != nil && kids.length > 0
  
      # replace children with nested hashes recursively
      for i in 0 .. kids.length
        cid = kids[i]
        if @parents[cid] != nil && @parents[cid].length > 0
          grandkids = find_children(cid)
          kids[i] = {cid => grandkids}
        end
      end
    end
    kids
  end

  def loadObjects (object,className)
    objects = []
    object.values.each do |name|
      name_uri = name.to_s
      name_pid = name_uri.gsub(/.*\//,'')
      if name_pid != nil && name_pid != ""
        objects << className.find(name_pid)
      end
    end 
  	return objects
  end
  
  def insertFields (solr_doc, fieldName, objects)
    if objects != nil
      n = 0
      objects.each do |obj|
          n += 1
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_id", obj.pid)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_name", obj.name)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_authority", obj.authority)
          Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_valueURI", obj.valueURI.first.to_s)
		  list = obj.elementList.first
		  i = 0
		  if list != nil		 
			while i < list.size  do		
			  Solrizer.insert_field(solr_doc, "#{fieldName}_element_#{n}_#{i}", list[i].elementValue.first)																															
			  i +=1
			end   
		  end          
      end
    end        
  end
  
  def insertNoteFields (solr_doc, fieldName, objects)
    n = 0
    objects.map do |no| 
      n += 1
      if (no.external?)
 		Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_id", no.load.pid)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_type", no.load.type)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_value", no.load.value)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_displayLabel", no.load.displayLabel)      
      else
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_type", no.type)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_value", no.value)
        Solrizer.insert_field(solr_doc, "#{fieldName}_#{n}_displayLabel", no.displayLabel)      	
      end
    end  
  
  end
  
  def to_solr (solr_doc = {})

    # field types
    storedInt = Solrizer::Descriptor.new(:integer, :indexed, :stored)
    singleString = Solrizer::Descriptor.new(:string, :indexed, :stored)
    storedIntMulti = Solrizer::Descriptor.new(:integer, :indexed, :stored, :multivalued)
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)

    subject_node.map do |sn| 
      subject_value = sn.external? ? sn.load.name : sn.authoritativeLabel
      Solrizer.insert_field(solr_doc, 'subject', subject_value)
      Solrizer.insert_field(solr_doc, 'subject_topic', subject_value,facetable)
    end
    Solrizer.insert_field(solr_doc, 'title', title)
    n = 0
    title_node.map do |t|
      n += 1
      Solrizer.insert_field(solr_doc, "title_#{n}_type", t.type)
      Solrizer.insert_field(solr_doc, "title_#{n}_subtitle", t.subtitle)
      Solrizer.insert_field(solr_doc, "title_#{n}_value", t.value)
    end  

    n = 0
    odate.map do |date|
      n += 1
      Solrizer.insert_field(solr_doc, "date_#{n}_beginDate", date.beginDate)
      Solrizer.insert_field(solr_doc, "date_#{n}_endDate", date.endDate)
      Solrizer.insert_field(solr_doc, "date_#{n}_value", date.value)
    end 
        
    #Solrizer.insert_field(solr_doc, 'date', date)
    
    relationship.map do |relationship| 
      Solrizer.insert_field(solr_doc, 'name', relationship.load.name )
    end
    Solrizer.insert_field(solr_doc, "resource_type", resource_type.first)
    Solrizer.insert_field(solr_doc, "object_type", resource_type.first,facetable)

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
    
    rightsHolders = load_rightsHolders
    if rightsHolders != nil
      n = 0
      rightsHolders.each do |name|
        if name.class == MadsPersonalName
          n += 1
          Solrizer.insert_field(solr_doc, "rightsHolder_#{n}_id", name.pid)
          Solrizer.insert_field(solr_doc, "rightsHolder_#{n}_name", name.name)
        end
      end
    end
    
    unit = load_unit
    if unit.class == DamsUnit
      Solrizer.insert_field(solr_doc, 'unit_code', unit.code)
      Solrizer.insert_field(solr_doc, 'unit_name', unit.name)
      Solrizer.insert_field(solr_doc, 'unit', unit.name, facetable)
      Solrizer.insert_field(solr_doc, 'unit_id', unit.pid)
    end

    source_capture = load_source_capture
    if source_capture.class == DamsSourceCapture
      Solrizer.insert_field(solr_doc, 'source_capture_scanner_manufacturer', source_capture.scannerManufacturer)
      Solrizer.insert_field(solr_doc, 'source_capture_source_type', source_capture.sourceType)
      Solrizer.insert_field(solr_doc, 'source_capture_scanner_model_name', source_capture.scannerModelName)
      Solrizer.insert_field(solr_doc, 'source_capture_image_producer', source_capture.imageProducer)
      Solrizer.insert_field(solr_doc, 'source_capture_scanning_software_version', source_capture.scanningSoftwareVersion)
      Solrizer.insert_field(solr_doc, 'source_capture_scanning_software', source_capture.scanningSoftware)
      Solrizer.insert_field(solr_doc, 'source_capture_capture_source', source_capture.captureSource)
      Solrizer.insert_field(solr_doc, 'source_capture_id', source_capture.pid)
    end
    
    col = load_collection
    if col != nil
     n = 0
      col.each do |collection|
        n += 1
        Solrizer.insert_field(solr_doc, "collection_#{n}_id", collection.pid)
        Solrizer.insert_field(solr_doc, "collection_#{n}_name", collection.title.first.value)      
      end
    end

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
      n = 0
      component.title.map do |title|
        n += 1
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_title", title.value)
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_subtitle", title.subtitle)
      end
      
      Solrizer.insert_field(solr_doc, "component_#{cid}_resource_type", component.resource_type.first)

      n = 0
      component.date.map do |date|
        n += 1
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_date", date.value)
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_beginDate", date.beginDate)
      	Solrizer.insert_field(solr_doc, "component_#{cid}_#{n}_endDate", date.endDate)
      end     
      if component.note.first != nil
        Solrizer.insert_field(solr_doc, "component_#{cid}_note", component.note.first.value)
      end
      component.file.map.sort{ |a,b| a.order <=> b.order }.each { |file|
        fid = file.id
        if !fid.ends_with? ".keep"
          Solrizer.insert_field(solr_doc, "component_#{cid}_files", fid)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_label", file.value)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_size", file.size, singleString)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_sourcePath", file.sourcePath)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_sourceFileName", file.sourceFileName)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_formatName", file.formatName)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_mimeType", file.mimeType)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_use", file.use)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_dateCreated", file.dateCreated)
          Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_quality", file.quality)
        end
      }
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

    file.map.sort{ |a,b| a.order <=> b.order }.each { |file|
      fid = file.id
      Solrizer.insert_field(solr_doc, "files", fid)
      Solrizer.insert_field(solr_doc, "file_#{fid}_label", file.value)
      Solrizer.insert_field(solr_doc, "file_#{fid}_size", file.size, singleString)
      Solrizer.insert_field(solr_doc, "file_#{fid}_sourcePath", file.sourcePath)
      Solrizer.insert_field(solr_doc, "file_#{fid}_sourceFileName", file.sourceFileName)
      Solrizer.insert_field(solr_doc, "file_#{fid}_formatName", file.formatName)
      Solrizer.insert_field(solr_doc, "file_#{fid}_mimeType", file.mimeType)
      Solrizer.insert_field(solr_doc, "file_#{fid}_use", file.use)
      Solrizer.insert_field(solr_doc, "file_#{fid}_dateCreated", file.dateCreated)
      Solrizer.insert_field(solr_doc, "file_#{fid}_quality", file.quality)
    }
    n = 0
    relatedResource.map do |resource|
      n += 1
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_type", resource.type)
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_uri", resource.uri)
      Solrizer.insert_field(solr_doc, "relatedResource_#{n}_description", resource.description)
    end
#	n = 0
#    note_node.map do |no|
#      n += 1
#      Solrizer.insert_field(solr_doc, "note_#{n}_type", no.type)
#      Solrizer.insert_field(solr_doc, "note_#{n}_displayLabel", no.displayLabel)
#      Solrizer.insert_field(solr_doc, "note_#{n}_value", no.value)
#    end

    insertNoteFields solr_doc, 'scopeContentNote',scopeContentNote
    insertNoteFields solr_doc, 'preferredCitationNote',preferredCitationNote
    insertNoteFields solr_doc, 'custodialResponsibilityNote',custodialResponsibilityNote
    insertNoteFields solr_doc, 'note',note
           
    insertFields solr_doc, 'iconography', load_iconographies
    insertFields solr_doc, 'scientificName', load_scientificNames
    insertFields solr_doc, 'technique', load_techniques
    insertFields solr_doc, 'occupation', load_occupations
    insertFields solr_doc, 'builtWorkPlace', load_builtWorkPlaces
    insertFields solr_doc, 'geographic', load_geographics
    insertFields solr_doc, 'temporal', load_temporals
    insertFields solr_doc, 'culturalContext', load_culturalContexts
    insertFields solr_doc, 'stylePeriod', load_stylePeriods
    insertFields solr_doc, 'topic', load_topics
    insertFields solr_doc, 'function', load_functions
    insertFields solr_doc, 'genreForm', load_genreForms
    
    insertFields solr_doc, 'personalName', load_personalNames    
    insertFields solr_doc, 'familyName', load_familyNames
    insertFields solr_doc, 'name', load_names
    insertFields solr_doc, 'conferenceName', load_conferenceNames
    insertFields solr_doc, 'corporateName', load_corporateNames
    insertFields solr_doc, 'complexSubject', load_complexSubjects
        
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

