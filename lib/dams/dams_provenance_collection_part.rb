require 'active_support/concern'

module Dams
  module DamsProvenanceCollectionPart
    extend ActiveSupport::Concern
    
    included do
       rdf_type DAMS.ProvenanceCollectionPart

       map_predicates do |map|
        map.title(:in => DAMS, :class_name => 'MadsTitle')
        map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
        map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
        map.language(:in=>DAMS, :class_name => 'MadsLanguageInternal')
        map.visibility(:in=>DAMS)
        map.resource_type(:in=>DAMS, :to => 'typeOfResource')

        # notes
        map.note(:in => DAMS, :to=>'note', :class_name => 'DamsNoteInternal')
        map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'DamsCustodialResponsibilityNoteInternal')
        map.preferredCitationNote(:in => DAMS, :to=>'preferredCitationNote', :class_name => 'DamsPreferredCitationNoteInternal')
        map.scopeContentNote(:in => DAMS, :to=>'scopeContentNote', :class_name => 'DamsScopeContentNoteInternal')

        # subjects
        map.subject(:in => DAMS, :to=> 'subject',  :class_name => 'Subject')
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
        map.relatedResource(:in => DAMS, :class_name => 'RelatedResource')
        map.event(:in=>DAMS, :class_name => 'DamsEventInternal')

        # collections
        map.collection(:in => DAMS)
        map.assembledCollection(:in => DAMS, :class_name => 'DamsAssembledCollectionInternal')
        map.provenanceCollection(:in => DAMS, :class_name => 'DamsProvenanceCollectionInternal')
        map.provenanceCollectionPart(:in => DAMS, :class_name => 'DamsProvenanceCollectionPartInternal')

        # related collections
        map.relatedCollection(:in => DAMS)

        # related objects
        map.object(:in => DAMS, :to => 'hasObject')
      end

      accepts_nested_attributes_for :title, :date, :relationship, :language, :visibility, :resource_type,
                      :note, :custodialResponsibilityNote, :preferredCitationNote, :scopeContentNote, 
                      :complexSubject, :builtWorkPlace, :culturalContext, :function, :genreForm, :geographic, 
                      :iconography, :occupation, :scientificName, :stylePeriod, :technique, :temporal, :topic,
                    :name, :conferenceName, :corporateName, :familyName, :personalName, :relatedResource,
                    :assembledCollection, :provenanceCollection, :provenanceCollectionPart

      rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

      def serialize
          graph.insert([rdf_subject, RDF.type, DAMS.ProvenanceCollectionPart]) if new?
          if(!@langURI.nil?)
            if new?
              graph.insert([rdf_subject, DAMS.language, @langURI])
            else
              graph.update([rdf_subject, DAMS.language, @langURI])
            end
          end   
          if(!@damsObjURI.nil?)
            if new?
              graph.insert([rdf_subject, DAMS.object, @damsObjURI])
            else
              graph.update([rdf_subject, DAMS.object, @damsObjURI])
            end
          end  
          if(!@provenanceCollURI.nil?)
            if new?
              graph.insert([rdf_subject, DAMS.provenanceCollection, @provenanceCollURI])
            else
              graph.update([rdf_subject, DAMS.provenanceCollection, @provenanceCollURI])
            end
          end  
          insertSubjectsGraph 
          insertNameGraph 
          super
       end
  
       def insertSubjectsGraph
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
        if(!@simpleSubURI.nil? && !subjectType.nil? && subjectType.length > 0)
            if new?
              graph.insert([rdf_subject, RDF::URI.new("#{DAMS}#{subjectType.first.camelize(:lower)}"), @simpleSubURI])
            else
              graph.update([rdf_subject, RDF::URI.new("#{DAMS}#{subjectType.first.camelize(:lower)}"), @simpleSubURI])
            end
          end     
        end

       def insertNameGraph  
        if(!@name_URI.nil? && !nameType.nil? && nameType.length > 0)
            if new?
              graph.insert([rdf_subject, RDF::URI.new("#{DAMS}#{nameType.first.camelize(:lower)}"), @name_URI])
            else
              graph.update([rdf_subject, RDF::URI.new("#{DAMS}#{nameType.first.camelize(:lower)}"), @name_URI])
            end
          end     
        end  

        def to_solr (solr_doc = {})
          Solrizer.insert_field(solr_doc, 'type', 'Collection')   
          Solrizer.insert_field(solr_doc, 'type', 'ProvenanceCollectionPart')
          Solrizer.insert_field(solr_doc, 'resource_type', resource_type)
          Solrizer.insert_field(solr_doc, 'visibility', visibility)
        super
        end

   end  
  end
end
