class DamsObjectDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.resource_type(:in => DAMS, :to => 'typeOfResource')
    map.title_node(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.collection(:in => DAMS)#, :class_name => 'AssembledCollection')
    map.subject_node(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
    map.odate(:in => DAMS, :to=>'date', :class_name => 'Date')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.note(:in => DAMS, :to=>'note', :class_name => 'Note')
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.component(:in => DAMS, :to=>'hasComponent', :class_name => 'Component')
    map.file(:in => DAMS, :to=>'hasFile', :class_name => 'File')
 end

# DAMS Object links/properties from data dictionary
#
# not mapped:
#   in-object:
#   Related Resource (relatedResource 0-m)
#
#   links:
#   Repository (repository 1)
#   Collection (collection 0-m)
#   Language (language 1-m)
#   Copyright (copyright 1)
#   Statute (statute, 0-1)
#   License (license, 0-1)
#   Other Rights (otherRights, 0-1)
#   Name (rightsHolder 0-m)
#   DAMS Event (event 1-m) 
#
# mapped:
#   typeOfResource
#   Title (title 1-m)
#   File (hasFile 0-m)
#   Subject (subject 0-m)
#   Date (date 0-m)
#   Component (hasComponent 0-m)
#   Relationship (relationship 0-m)
#   Note (note 0-m)

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.repository_root + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Object]) if new?
    super
  end

  class Component
    include ActiveFedora::RdfObject
    rdf_type DAMS.Component
    rdf_subject { |ds| RDF::URI.new(Rails.configuration.repository_root + ds.pid)}
    map_predicates do |map|     
      map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
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
      rdf_subject.to_s.include? Rails.configuration.repository_root
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

  def to_solr (solr_doc = {})
    subject_node.map do |sn| 
      subject_value = sn.external? ? sn.load.name : sn.authoritativeLabel
      Solrizer.insert_field(solr_doc, 'subject', subject_value)
    end
    Solrizer.insert_field(solr_doc, 'title', title)
    Solrizer.insert_field(solr_doc, 'date', date)
    relationship.map do |relationship| 
      Solrizer.insert_field(solr_doc, 'name', relationship.load.name )
    end
    component.map do |component|
      cid = component.rdf_subject.to_s
      cid = cid.match('\w+$')
      Solrizer.insert_field(solr_doc, "component_#{cid}_title", component.title.first.value)
      Solrizer.insert_field(solr_doc, "component_#{cid}_date",  component.date.first.value)
      if component.note.first != nil
        Solrizer.insert_field(solr_doc, "component_#{cid}_note",  component.note.first.value)
      end
      component.file.map do |file|
        fid = file.rdf_subject.to_s
        fid = fid.gsub(/.*\//,'')
        Solrizer.insert_field(solr_doc, "component_#{cid}_file_#{fid}_size",  file.size)
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
      Solrizer.insert_field(solr_doc, "file_#{fid}_size",  file.size)
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

