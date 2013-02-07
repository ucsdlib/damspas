class DamsProvenanceCollectionDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.date(:in => DAMS, :to=>'date', :class_name => 'Date')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'ScopeContentNote')
    map.note(:in => DAMS, :to=>'note', :class_name => 'Note')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.subject_node(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.language(:in=>DAMS, :class_name => 'DamsLanguage')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.ProvenanceCollection]) if new?
    super
  end

  def titleValue
    title[0] ? title[0].value : []
  end
  def titleValue=(val)
    title.build if title[0] == nil
    title[0].value = val
  end

  def titleType
    title[0] ? title[0].type : []
  end
  def titleType=(val)
    title.build if title[0] == nil
    title[0].type = val
  end

  def dateValue
    date[0] ? date[0].value : []
  end
  def dateValue=(val)
    date.build if date[0] == nil
    date[0].value = val
  end

  def beginDate
    date[0] ? date[0].beginDate : []
  end
  def beginDate=(val)
    date.build if date[0] == nil
    date[0].beginDate = val
  end

  def endDate
    date[0] ? date[0].endDate : []
  end
  def endDate=(val)
    date.build if date[0] == nil
    date[0].endDate = val
  end

  def scopeContentNoteValue
    scopeContentNote[0] ? scopeContentNote[0].value : []
  end
  def scopeContentNoteValue=(val)
    scopeContentNote.build if scopeContentNote[0] == nil
    scopeContentNote[0].value = val
  end

  def scopeContentNoteType
    scopeContentNote[0] ? scopeContentNote[0].type : []
  end
  def scopeContentNoteType=(val)
    scopeContentNote.build if scopeContentNote[0] == nil
    scopeContentNote[0].type = val
  end

  def scopeContentNoteDisplayLabel
    scopeContentNote[0] ? scopeContentNote[0].displayLabel : []
  end
  def scopeContentNoteDisplayLabel=(val)
    scopeContentNote.build if scopeContentNote[0] == nil
    scopeContentNote[0].displayLabel = val
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
  class Date
    include ActiveFedora::RdfObject
    rdf_type DAMS.Date
    map_predicates do |map|    
      map.value(:in=> RDF)
      map.beginDate(:in=>DAMS)
      map.endDate(:in=>DAMS)
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
  class RelatedResource
    include ActiveFedora::RdfObject
    rdf_type DAMS.RelatedResource
    map_predicates do |map|    
      map.type(:in=> DAMS)
      map.description(:in=> DAMS)
      map.uri(:in=> DAMS)
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

  def to_solr (solr_doc = {})
    # need to make these support multiples too
    Solrizer.insert_field(solr_doc, 'title', title.first.value)
    Solrizer.insert_field(solr_doc, 'date', date.first.value)

    subject_node.map do |sn| 
      subject_value = sn.external? ? sn.load.name : sn.authoritativeLabel
      Solrizer.insert_field(solr_doc, 'subject', subject_value)
    end
    relationship.map do |relationship| 
      Solrizer.insert_field(solr_doc, 'name', relationship.load.name )
    end
    note.map do |note|
      #map.value(:in=> RDF)
      #map.displayLabel(:in=>DAMS)
      #map.type(:in=>DAMS)
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
