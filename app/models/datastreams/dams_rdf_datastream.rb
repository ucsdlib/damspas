class DamsRdfDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.resource_type(:in => DAMS, :to => 'typeOfResource')
    map.title_node(:in => DAMS, :to=>'title', :class_name => 'Description')
    map.collection(:in => DAMS)#, :class_name => 'AssembledCollection')
    map.subject_node(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.date_node(:in => DAMS, :to=>'date', :class_name => 'Date')
 end

  rdf_subject { |ds| RDF::URI.new("http://library.ucsd.edu/ark:/20775/#{ds.pid}")}


  after_initialize :type_resource
  def type_resource
    graph.insert([rdf_subject, RDF.type, DAMS.Object])
  end

  class Description
    include ActiveFedora::RdfObject
    rdf_type DAMS.Title
    map_predicates do |map|   
      map.value(:in=> RDF)
    end
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


  def title
    title_node.first.value
  end

  def title=(val)
    self.title_node = []
    title_node.build.value = val
  end

  def date
    date_node.first.value if date_node.first
  end

  def date=(val)
    self.date_node = []
    date_node.build.value = val
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
  
  class Subject
    include ActiveFedora::RdfObject
    rdf_type MADS.ComplexSubject
    map_predicates do |map|      
      map.authoritativeLabel(:in=> MADS)
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

  class Date
    include ActiveFedora::RdfObject
    rdf_type DAMS.Date
    map_predicates do |map|    
      map.value(:in=> RDF)
    end
  end

  def to_solr (solr_doc = {})
    solr_doc["subject_t"] = subject
    solr_doc["title_t"] = title
    solr_doc["date_t"] = date
    solr_doc["name_t"] = relationship.map{|relationship| relationship.load.name}.flatten
    return solr_doc
  end
end

