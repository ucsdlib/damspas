class DamsSubjectDatastream < ActiveFedora::RdfxmlRDFDatastream

  map_predicates do |map|
    map.name(:in => MADS, :to => 'authoritativeLabel')
    map.elementList(:in => MADS, :to => 'elementList', :class_name=>'List')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}


  class List 
    include ActiveFedora::RdfList
    class TopicElement
      include ActiveFedora::RdfObject
      rdf_type MADS.TopicElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end
    class TemporalElement
      include ActiveFedora::RdfObject
      rdf_type MADS.TemporalElement
      map_predicates do |map|   
        map.elementValue(:in=> MADS)
      end
    end
  end

  
  def serialize
    graph.insert([rdf_subject, RDF.type, MADS.ComplexSubject]) if new?
    super
  end
end
