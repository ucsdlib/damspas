class DamsProvenanceCollectionPartDatastream < DamsCollectionDatastream
  map_predicates do |map|
    map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.date(:in => DAMS, :to=>'date', :class_name => 'Date')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'ScopeContentNote')
    map.note(:in => DAMS, :to=>'note', :class_name => 'Note')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
    map.subject_node(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.language(:in=>DAMS)
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'CustodialResponsibilityNote')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'PreferredCitationNote')   
    map.occupation(:in => DAMS)
    map.genreForm(:in => DAMS)
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
    map.event(:in=>DAMS)
    map.collection(:in => DAMS)
    map.assembledCollection(:in => DAMS)
    map.provenanceCollection(:in => DAMS)
    map.provenanceCollectionPart(:in => DAMS)
 end
  def load_collection
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
  
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.ProvenanceCollectionPart]) if new?
    super
  end

 
  def to_solr (solr_doc = {})   
    Solrizer.insert_field(solr_doc, 'type', 'ProvenanceCollectionPart')
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    col = load_collection
    if col != nil
     n = 0
      col.each do |collection|
        n += 1
        Solrizer.insert_field(solr_doc, "collections", collection.pid)
        Solrizer.insert_field(solr_doc, "collection_#{n}_id", collection.pid)
        Solrizer.insert_field(solr_doc, "collection_#{n}_name", collection.title.first.value)
        Solrizer.insert_field(solr_doc, "collection", collection.title.first.value, facetable)
        if ( collection.kind_of? DamsAssembledCollection )
          Solrizer.insert_field(solr_doc, "collection_#{n}_type", "AssembledCollection")
        elsif ( collection.kind_of? DamsProvenanceCollectionPart )
          Solrizer.insert_field(solr_doc, "collection_#{n}_type", "ProvenanceCollectionPart")
        elsif ( collection.kind_of? DamsProvenanceCollection )
          Solrizer.insert_field(solr_doc, "collection_#{n}_type", "ProvenanceCollection")
        end
      end
    end
	super
  end
end
