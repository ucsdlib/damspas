class DamsObjectDatastream < DamsResourceDatastream
  map_predicates do |map|
    map.title(:in => DAMS, :to=>'title', :class_name => 'Title')
    map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
    map.language(:in=>DAMS, :class_name => 'DamsLanguageInternal')

    # notes
    map.note(:in => DAMS, :to=>'note', :class_name => 'DamsNoteInternal')
    map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'DamsCustodialResponsibilityNoteInternal')
    map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'DamsPreferredCitationNoteInternal')
    map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'DamsScopeContentNoteInternal')

    # subjects
    map.subject(:in => DAMS, :to=> 'subject', :class_name => 'MadsComplexSubjectInternal')
    map.complexSubject(:in => DAMS, :class_name => 'MadsComplexSubjectInternal')
    map.builtWorkPlace(:in => DAMS, :class_name => 'DamsBuiltWorkPlaceInternal')
    map.culturalContext(:in => DAMS, :class_name => 'DamsCulturalContextInternal')
    map.function(:in => DAMS, :class_name => 'DamsFunctionInternal')
    map.genreForm(:in => DAMS, :class_name => 'MadsGenreFormInternal')
    map.geographic(:in => DAMS, :class_name => 'MadsGeographicInternal')
    map.iconography(:in => DAMS, :class_name => 'DamsIconographyInternal')
    map.occupation(:in => DAMS, :class_name => 'MadsOccupationInternal')
    map.scientificName(:in => DAMS, :class_name => 'DamsScientificNameInternal')
    map.stylePeriod(:in => DAMS, :class_name => 'DamsStylePeriodInternal')
    map.technique(:in => DAMS, :class_name => 'DamsTechniqueInternal')
    map.temporal(:in => DAMS, :class_name => 'MadsTemporalInternal')
    map.topic(:in => DAMS, :class_name => 'MadsTopicInternal')

    # subject names
    map.name(:in => DAMS, :class_name => 'MadsNameInternal')
    map.conferenceName(:in => DAMS, :class_name => 'MadsConferenceNameInternal')
    map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')
    map.familyName(:in => DAMS, :class_name => 'MadsFamilyNameInternal')
    map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')

    # related resources and events
    map.relatedResource(:in => DAMS, :to=>'otherResource', :class_name => 'RelatedResource')
    map.event(:in=>DAMS, :class_name => 'DamsDAMSEventInternal')

    # unit and collections
    map.unit(:in => DAMS, :to=>'unit', :class_name => 'DamsUnitInternal')
    map.collection(:in => DAMS)
    map.assembledCollection(:in => DAMS, :class_name => 'DamsAssembledCollectionInternal')
    map.provenanceCollection(:in => DAMS, :class_name => 'DamsProvenanceCollectionInternal')
    map.provenanceCollectionPart(:in => DAMS, :class_name => 'DamsProvenanceCollectionPartInternal')

    # components and files
    map.component(:in => DAMS, :to=>'hasComponent', :class_name => 'Component')
    map.file(:in => DAMS, :to=>'hasFile', :class_name => 'DamsFile')

    # rights
    map.copyright(:in=>DAMS,:class_name => 'DamsCopyrightInternal')
    map.license(:in=>DAMS,:class_name => 'DamsLicenseInternal')
    map.otherRights(:in=>DAMS,:class_name => 'DamsOtherRightsInternal')
    map.statute(:in=>DAMS,:class_name => 'DamsStatuteInternal')
    map.rightsHolder(:in=>DAMS,:class_name => 'DamsRightsHolderInternal')

    # resource type and cartographics
    map.typeOfResource(:in => DAMS, :to => 'typeOfResource')
    map.cartographics(:in => DAMS, :class_name => 'Cartographics')
  end
 
  rdf_subject { |ds|
    RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
  }
  
  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Object]) if new?
    if(!@subURI.nil?)
      if new?
        @array_subject.each do |sub|
        	graph.insert([rdf_subject, DAMS.subject, sub])
        end
        #graph.insert([rdf_subject, DAMS.subject, @subURI])
      else
        graph.update([rdf_subject, DAMS.subject, @subURI])
      end
    end  
	if(!@unitURI.nil?)
      if new?
        graph.insert([rdf_subject, DAMS.unit, @unitURI])
      else
        graph.update([rdf_subject, DAMS.unit, @unitURI])
      end
    end          
    super
  end

  def load_unit(unit)
	if !unit.values.first.nil?
	    u_pid = unit.values.first.pid
	    
	    if !unit.values.first.name.first.nil? && unit.values.first.name.first.to_s.length > 0
	      unit.values.first
	    else
	      DamsUnit.find(u_pid)
	    end
	else
		nil
	end

  end

  def load_collection (collection,assembledCollection,provenanceCollection,provenanceCollectionPart)
    collections = []
    [collection,assembledCollection,provenanceCollection,provenanceCollectionPart].each do |coltype|
      coltype.values.each do |col|
        collection_uri = col.to_s
	    collection_pid = collection_uri.gsub(/.*\//,'')
	    hasModel = ""
        if (collection_pid != nil && collection_pid != "" && !(collection_pid.include? 'Internal'))
           obj = DamsAssembledCollection.find(collection_pid)
      	   hasModel = obj.relationships(:has_model).to_s
      	else
      	   collections << col
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
  
  def load_copyright ( copyright )
	if !copyright.values.first.nil?
	    c_pid = copyright.values.first.pid
	    if !copyright.values.first.status.first.nil? && copyright.values.first.status.to_s.length > 0
	      copyright.values.first
	    else
	      DamsCopyright.find(c_pid)
	    end
	else
		nil
	end
  end
  def load_license
    load_license(license)
  end
  def load_license (license)
	if !license.values.first.nil?
	    l_pid = license.values.first.pid
	    
	    if (!license.values.first.note.first.nil? && license.values.first.note.first.length > 0) || ( !license.values.first.uri.first.nil? && license.values.first.uri.first.to_s.length > 0)
	      license.values.first
	    else
	      DamsLicense.find(l_pid)
	    end
	end    
  end
  def load_statute
    load_statute(statute)
  end
  def load_statute (statute)    
	if !statute.values.first.nil?
	    s_pid = statute.values.first.pid
	    if !statute.values.first.citation.first.nil? && statute.values.first.citation.first.to_s.length > 0
	      statute.values.first
	    else
	      DamsStatute.find(s_pid)
	    end
	end        
  end
  def load_otherRights
    load_otherRights(otherRights)
  end
  def load_otherRights (otherRights)
	if !otherRights.values.first.nil?
	    o_pid = otherRights.values.first.pid
	    if !otherRights.values.first.uri.first.nil? && otherRights.values.first.uri.first.to_s.length > 0
	      otherRights.values.first
	    else
	      DamsOtherRights.find(o_pid)
	    end
	end        
  end

  def load_sourceCapture(sourceCapture)
    uri = sourceCapture.values.first.to_s
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
      if !name.name.first.nil? && name.name.first != ""
        # use inline data if available
        rightsHolders << name
      elsif name.pid != nil
        rightsHolders << MadsPersonalName.find(name.pid)
      end
    end
    rightsHolders
  end

  def insertFileFields( solr_doc, cid, files )
    prefix = (cid != nil) ? "component_#{cid}_" : ""
    files.map.sort{ |a,b| a.order <=> b.order }.each { |file|

      # basic file info
      file_json = {
        :filestore => file.filestore.first.to_s,
        :id => file.id,
        :quality => file.quality.first.to_s,
        :size => file.size.first.to_s,
        :sourcePath => file.sourcePath.first.to_s,
        :sourceFileName => file.sourceFileName.first.to_s,
        :use => file.use.first.to_s,
        :label => file.value.first.to_s,
        :dateCreated => file.dateCreated.first.to_s,
        :formatName => file.formatName.first.to_s,
        :mimeType => file.mimeType.first.to_s }

      # source capture
      srcCap = load_sourceCapture file.sourceCapture
      if srcCap.class == DamsSourceCapture
        file_json[:source_capture] = srcCap.pid
        file_json[:capture_source] = srcCap.captureSource.first.to_s
        file_json[:image_producer] = srcCap.imageProducer.first.to_s
        file_json[:scanner_manufacturer] = srcCap.scannerManufacturer.first.to_s
        file_json[:scanner_model_name] = srcCap.scannerModelName.first.to_s
        file_json[:scanning_software] = srcCap.scanningSoftware.first.to_s
        file_json[:scanning_software_version] = srcCap.scanningSoftwareVersion.first.to_s
        file_json[:source_type] = srcCap.sourceType.first.to_s
      end

      # events
      #event_array = events_to_json file.event
      #file_json[:events] = event_array

      Solrizer.insert_field(solr_doc, "#{prefix}files", file_json.to_json)
      Solrizer.insert_field(solr_doc, "fulltext", file_json.to_json)

      # fulltext extraction for pdfs
      if file.mimeType.first.to_s == "application/pdf"
        if @parent_obj == nil
          @parent_obj = ActiveFedora::Base.find(pid, :cast=>true)
        end
        begin
          fulltext = @parent_obj.datastreams[ "fulltext_#{file.id}" ]
          if fulltext != nil
            Solrizer.insert_field(solr_doc, "fulltext", fulltext.content)
          end
        rescue Exception => e
          puts "Error retrieving fulltext content: fulltext_#{file.id}: #{e.message}"
        end
      end

      # insert solr field
      pre = (cid != nil) ? "file_#{cid}_" : "file_"
      Solrizer.insert_field(solr_doc, "#{pre}#{file.id}_filestore", file.filestore.first.to_s)
    }
  end
  def insertCopyrightFields ( solr_doc, prefix, copyright )
    copy = load_copyright copyright
    if copy != nil
      copy_json = {
        :id => copy.pid,
        :status => copy.status.first.to_s,
        :jurisdiction => copy.jurisdiction.first.to_s,
        :purposeNote => copy.purposeNote.first.to_s,
        :note => copy.note.first.to_s,
        :beginDate => copy.beginDate.first.to_s }
      Solrizer.insert_field(solr_doc, "#{prefix}copyright", copy_json.to_json)
      Solrizer.insert_field(solr_doc, "fulltext", copy_json.to_json)
    end
  end
  def insertLicenseFields( solr_doc, prefix, license )
    lic = load_license license
    if lic != nil
      lic_json = {
        :id => lic.pid,
        :note => lic.note.first.to_s,
        :uri => lic.uri.values.first.to_s,
        :permissionType => lic.permissionType.first.to_s,
        :permissionBeginDate => lic.permissionBeginDate.first.to_s,
        :permissionEndDate => lic.permissionEndDate.first.to_s,
        :restrictionType => lic.restrictionType.first.to_s,
        :restrictionBeginDate => lic.restrictionBeginDate.first.to_s,
        :restrictionEndDate => lic.restrictionEndDate.first.to_s }
      Solrizer.insert_field(solr_doc, "#{prefix}license", lic_json.to_json)
      Solrizer.insert_field(solr_doc, "fulltext", lic_json.to_json)
    end
  end
  def insertStatuteFields( solr_doc, prefix, statute )
    stat = load_statute statute
    if stat != nil
      stat_json = {
        :id => stat.pid,
        :citation => stat.citation.first.to_s,
        :jurisdiction => stat.jurisdiction.first.to_s,
        :note => stat.note.first.to_s,
        :permissionType => stat.permissionType.first.to_s,
        :permissionBeginDate => stat.permissionBeginDate.first.to_s,
        :permissionEndDate => stat.permissionEndDate.first.to_s,
        :restrictionType => stat.restrictionType.first.to_s,
        :restrictionBeginDate => stat.restrictionBeginDate.first.to_s,
        :restrictionEndDate => stat.restrictionEndDate.first.to_s }
      Solrizer.insert_field(solr_doc, "#{prefix}statute", stat_json.to_json)
      Solrizer.insert_field(solr_doc, "fulltext", stat_json.to_json)
    end
  end
  def insertOtherRightsFields( solr_doc, prefix, otherRights )
    othr = load_otherRights otherRights
    if othr != nil
      othr_json = {
        :id => othr.pid,
        :basis => othr.basis.first.to_s,
        :note => othr.note.first.to_s,
        :uri => othr.uri.first.to_s,
        :permissionType => othr.permissionType.first.to_s,
        :permissionBeginDate => othr.permissionBeginDate.first.to_s,
        :permissionEndDate => othr.permissionEndDate.first.to_s,
        :restrictionType => othr.restrictionType.first.to_s,
        :restrictionBeginDate => othr.restrictionBeginDate.first.to_s,
        :restrictionEndDate => othr.restrictionEndDate.first.to_s
      }
      if othr.name.first != nil
        othr_json[:name] = "http://library.ucsd.edu/ark:/20775/#{othr.name.first.pid}"
      end
      if othr.role.first != nil
        othr_json[:role] = "http://library.ucsd.edu/ark:/20775/#{othr.role.first.pid}"
      end
      Solrizer.insert_field(solr_doc, "#{prefix}otherRights", othr_json.to_json)
      Solrizer.insert_field(solr_doc, "fulltext", othr_json.to_json)
    end    
  end
  def insertRightsHolderFields( solr_doc, prefix, rightsHolder )
    rightsHolders = load_rightsHolders rightsHolder
    if rightsHolders != nil
      rightsHolders.each do |name|
          Solrizer.insert_field(solr_doc, "#{prefix}rightsHolder", name.name.first.to_s)
          Solrizer.insert_field(solr_doc, "fulltext", name.name)
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

      Solrizer.insert_field(solr_doc, "component_#{cid}_resource_type", component.typeOfResource.first)
      Solrizer.insert_field(solr_doc, "object_type", component.typeOfResource.first,facetable)    
      Solrizer.insert_field(solr_doc, "fulltext", component.typeOfResource)

      insertDateFields solr_doc, cid, component.date
      insertRelationshipFields solr_doc, "component_#{cid}_", component.relationship
      insertLanguageFields solr_doc, "component_#{cid}_", component.language

      insertNoteFields solr_doc, "component_#{cid}_note",component.note
      insertNoteFields solr_doc, "component_#{cid}_custodialResponsibilityNote",component.custodialResponsibilityNote
      insertNoteFields solr_doc, "component_#{cid}_preferredCitationNote",component.preferredCitationNote
      insertNoteFields solr_doc, "component_#{cid}_scopeContentNote",component.scopeContentNote

      insertComplexSubjectFields solr_doc, cid, load_complexSubjects(component.complexSubject)
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

      # facetable topics
      insertFacets solr_doc, "subject_topic", load_topics(component.topic)
      insertFacets solr_doc, "component_#{cid}_subject_topic", load_topics(component.topic)

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
    
    u = load_unit unit
    if !u.nil?
      Solrizer.insert_field(solr_doc, 'unit', u.name, facetable)
      Solrizer.insert_field(solr_doc, 'unit_code', u.code)
      Solrizer.insert_field(solr_doc, 'fulltext', u.name)
      Solrizer.insert_field(solr_doc, 'fulltext', u.code)
      unit_json = {
        :id => u.pid,
        :code => u.code.first.to_s,
        :name => u.name.first.to_s
      }
      Solrizer.insert_field(solr_doc, 'unit_json', unit_json.to_json)
    end
    
    col = load_collection collection,assembledCollection,provenanceCollection,provenanceCollectionPart
    if col != nil
      col.each do |collection|
        Solrizer.insert_field(solr_doc, "collection", collection.titleValue, facetable)
        Solrizer.insert_field(solr_doc, "fulltext", collection.titleValue)
        Solrizer.insert_field(solr_doc, "collections", collection.pid)
        col_json = {
          :id => collection.pid,
          :name => collection.titleValue.first.to_s
        }

 		if ( collection.to_s.include? 'DamsProvenanceCollectionInternal' )
          col_json[:type] = "ProvenanceCollection"  
 		elsif ( collection.to_s.include? 'DamsAssembledCollectionInternal' )
          col_json[:type] = "AssembledCollection"        
 		elsif ( collection.to_s.include? 'DamsProvenanceCollectionPartInternal' )
          col_json[:type] = "ProvenanceCollectionPart"               
        elsif ( collection.kind_of? DamsAssembledCollection )
          col_json[:type] = "AssembledCollection"
        elsif ( collection.kind_of? DamsProvenanceCollectionPart )
          col_json[:type] = "ProvenanceCollectionPart"
        elsif ( collection.kind_of? DamsProvenanceCollection )
          col_json[:type] = "ProvenanceCollection"
                       
        end
        Solrizer.insert_field(solr_doc, 'collection_json', col_json.to_json)
      end
    end

    insertCopyrightFields solr_doc, "", copyright
    insertLicenseFields solr_doc, "", license
    insertStatuteFields solr_doc, "", statute
    insertOtherRightsFields solr_doc, "", otherRights
    insertRightsHolderFields solr_doc, "", rightsHolder
    
    cartographics.map do |cart|
      carto_json = {
        :point => cart.point,
        :line => cart.line,
        :polygon => cart.polygon,
        :projection => cart.projection,
        :referenceSystem => cart.referenceSystem,
        :scale => cart.scale }
      Solrizer.insert_field(solr_doc, "cartographics_json", carto_json.to_json)
      Solrizer.insert_field(solr_doc, "fulltext", carto_json.to_json)
    end 
    Solrizer.insert_field(solr_doc, "resource_type", typeOfResource.first)
    Solrizer.insert_field(solr_doc, "fulltext", typeOfResource)
    Solrizer.insert_field(solr_doc, "object_type", typeOfResource.first,facetable)    

    Solrizer.insert_field(solr_doc, "rdfxml", self.content, singleString)

	super
  end  
  
end

