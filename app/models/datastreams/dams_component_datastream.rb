class DamsComponentDatastream < DamsResourceDatastream
  include Dams::ModelHelper
  map_predicates do |map|
    map.title(:in => DAMS, :class_name => 'MadsTitle')
    map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
    map.language(:in=>DAMS, :class_name => 'MadsLanguageInternal')

    # notes
    map.note(:in => DAMS, :to=>'note', :class_name => 'DamsNoteInternal')
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'DamsCustodialResponsibilityNoteInternal')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'DamsPreferredCitationNoteInternal')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'DamsScopeContentNoteInternal')

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
    map.commonName(:in => DAMS)
    map.scientificName(:in => DAMS)
    map.stylePeriod(:in => DAMS)
    map.technique(:in => DAMS)
    map.temporal(:in => DAMS)
    map.topic(:in => DAMS)
    map.lithology(:in => DAMS)
    map.series(:in => DAMS)
    map.cruise(:in => DAMS)
    
    # subject names
    map.name(:in => DAMS, :class_name => 'MadsNameInternal')
    map.conferenceName(:in => DAMS, :class_name => 'MadsConferenceNameInternal')
    map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')
    map.familyName(:in => DAMS, :class_name => 'MadsFamilyNameInternal')
    map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')

    # related resources and events
    map.relatedResource(:in => DAMS, :class_name => 'DamsRelatedResourceInternal')
    map.event(:in=>DAMS, :class_name => 'DamsEventInternal')

    # unit and collections
    map.unit(:in => DAMS, :to=>'unit', :class_name => 'DamsUnitInternal')
    map.collection(:in => DAMS)
    map.assembledCollection(:in => DAMS, :class_name => 'DamsAssembledCollectionInternal')
    map.provenanceCollection(:in => DAMS, :class_name => 'DamsProvenanceCollectionInternal')
    map.provenanceCollectionPart(:in => DAMS, :class_name => 'DamsProvenanceCollectionPartInternal')

    # components and files
    map.component(:in => DAMS, :to=>'hasComponent', :class_name => 'DamsComponentInternal')
    #map.subcomponent(:in=>DAMS, :to=>'hasComponent', :class => 'DamsComponent')
    map.file(:in => DAMS, :to=>'hasFile', :class_name => 'DamsFile')

    # rights
    map.copyright(:in=>DAMS,:class_name => 'DamsCopyrightInternal')
    map.license(:in=>DAMS,:class_name => 'DamsLicenseInternal')
	map.otherRights(:in=>DAMS,:class_name => 'DamsOtherRightInternal')
    map.statute(:in=>DAMS,:class_name => 'DamsStatuteInternal')
    map.rightsHolder(:in=>DAMS,:class_name => 'DamsRightsHolderInternal')

    # resource type and cartographics
    map.typeOfResource(:in => DAMS, :to => 'typeOfResource')
    map.cartographics(:in => DAMS, :class_name => 'Cartographics')
 end
 
  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }


  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Component]) if new?
    super
  end

   
  def id
    cid = rdf_subject.to_s
    cid = cid.match('\w+$').to_s
    cid.to_i
  end

  def insertSourceCapture( solr_doc, cid, fid, sourceCapture )
    prefix = (cid != nil) ? "component_#{cid}_file_#{fid}" : "file_#{fid}"
    if sourceCapture.class == DamsSourceCapture
      Solrizer.insert_field(solr_doc, "#{prefix}_source_capture", sourceCapture.pid)
      Solrizer.insert_field(solr_doc, "#{prefix}_capture_source", sourceCapture.captureSource)
      Solrizer.insert_field(solr_doc, "#{prefix}_image_producer", sourceCapture.imageProducer)
      Solrizer.insert_field(solr_doc, "#{prefix}_scanner_manufacturer", sourceCapture.scannerManufacturer)
      Solrizer.insert_field(solr_doc, "#{prefix}_scanner_model_name", sourceCapture.scannerModelName)
      Solrizer.insert_field(solr_doc, "#{prefix}_scanning_software", sourceCapture.scanningSoftware)
      Solrizer.insert_field(solr_doc, "#{prefix}_scanning_software_version", sourceCapture.scanningSoftwareVersion)
      Solrizer.insert_field(solr_doc, "#{prefix}_source_type", sourceCapture.sourceType)
    end
  end
end

