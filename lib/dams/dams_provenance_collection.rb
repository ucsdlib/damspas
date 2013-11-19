require 'active_support/concern'

module Dams
  module DamsProvenanceCollection
    extend ActiveSupport::Concern
    include ModelHelper
    
    included do
      rdf_type DAMS.ProvenanceCollection
      

       map_predicates do |map|
        map.title(:in => DAMS, :to => 'title', :class_name => 'MadsTitle')
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
        map.relatedResource(:in => DAMS, :class_name => 'RelatedResource')
        map.event(:in=>DAMS, :class_name => 'DamsEventInternal')
        
        # collections
        map.collection(:in => DAMS)
        map.assembledCollection(:in => DAMS, :class_name => 'DamsAssembledCollectionInternal')
        map.provenanceCollection(:in => DAMS, :class_name => 'DamsProvenanceCollectionInternal')
        map.provenanceCollectionPart(:in => DAMS, :class_name => 'DamsProvenanceCollectionPartInternal')

        # child parts
        map.part_node(:in=>DAMS,:to=>'hasPart')

        # related collections
        map.relatedCollection(:in => DAMS)

        # related objects
        map.object(:in => DAMS, :to => 'hasObject', :class_name => 'DamsObject')
      end

      accepts_nested_attributes_for :title, :date, :relationship, :visibility,:language, :note,:resource_type,
                      :custodialResponsibilityNote, :preferredCitationNote, :scopeContentNote, 
                      :complexSubject, :builtWorkPlace, :culturalContext, :function, :genreForm, :geographic, 
                      :iconography, :occupation, :scientificName, :stylePeriod, :technique, :temporal, :topic,
                    :name, :conferenceName, :corporateName, :familyName, :personalName, :relatedResource,
                    :assembledCollection, :provenanceCollection, :provenanceCollectionPart, :part_node,:file,:allow_destroy => true   
      
      

    rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}
    
      def serialize
        check_type( graph, rdf_subject, DAMS.ProvenanceCollection )
        
        if(!@langURI.nil?)
          if(@langURI.class == Array)
            @langURI.each do |lang|
                  graph.insert([rdf_subject, DAMS.language, lang])
              end
          else
                if new?
                  graph.insert([rdf_subject, DAMS.language, @langURI])
                else
                  graph.update([rdf_subject, DAMS.language, @langURI])
                end     
          end
      end    
        if(!@damsObjURI.nil?)
          if new?
            graph.insert([rdf_subject, DAMS.object, @damsObjURI])
          else
            graph.update([rdf_subject, DAMS.object, @damsObjURI])
          end
        end  
        if(!@provenanceHasPartURI.nil?)
          if new?
            graph.insert([rdf_subject, DAMS.part_node, @provenanceHasPartURI])
          else
            graph.update([rdf_subject, DAMS.part_node, @provenanceHasPartURI])
          end
        end 
        if(!@provenanceCollPartURI.nil?)
          if new?
            graph.insert([rdf_subject, DAMS.provenanceCollectionPart, @provenanceCollPartURI])
          else
            graph.update([rdf_subject, DAMS.provenanceCollectionPart, @provenanceCollPartURI])
          end
        end 
        insertSubjectsGraph 
        insertNameGraph   
        super
      end

	  def insertSubjectsGraph
	    if(!@subURI.nil?)
			if(@subURI.class == Array)
				@subURI.each do |sub|
			        graph.insert([rdf_subject, DAMS.complexSubject, sub])
			    end
			else
		      if new?
		        graph.insert([rdf_subject, DAMS.complexSubject, @subURI])
		      else
		        graph.update([rdf_subject, DAMS.complexSubject, @subURI])
		      end			
			end	      
	    end
	        
		if(!@simpleSubURI.nil?)
			if(@simpleSubURI.class == Array)
				i = 0
				@simpleSubURI.each do |sub|
			        graph.insert([rdf_subject, RDF::URI.new("#{DAMS}#{@subType[i].camelize(:lower)}"), sub])
			        i = i + 1
			    end
			else
		      if new?
		        graph.insert([rdf_subject, RDF::URI.new("#{DAMS}#{@subType[0].camelize(:lower)}"), @simpleSubURI])
		      else
		        graph.update([rdf_subject, RDF::URI.new("#{DAMS}#{@subType[0].camelize(:lower)}"), @simpleSubURI])
		      end		
			end		      	      
	    end     
	  end
 
      def insertNameGraph  
      if(!@nameURI.nil?)
        if(@nameURI.class == Array)
          @nameURI.each do |nam|
                graph.insert([rdf_subject, DAMS.name, nam])
            end
        else
            if new?
              graph.insert([rdf_subject, DAMS.name, @nameURI])
            else
              graph.update([rdf_subject, DAMS.name, @nameURI])
            end     
        end       
        end
            
      if(!@creatorURI.nil?)
        if(@creatorURI.class == Array)
          i = 0
          @creatorURI.each do |crea|
                graph.insert([rdf_subject, RDF::URI.new("#{DAMS}#{@nameType[i].camelize(:lower)}"), crea])
                i = i + 1
            end
        else
            if new?
              graph.insert([rdf_subject, RDF::URI.new("#{DAMS}#{@nameType[0].camelize(:lower)}"), @nameURI])
            else
              graph.update([rdf_subject, RDF::URI.new("#{DAMS}#{@nameType[0].camelize(:lower)}"), @nameURI])
            end   
        end                 
        end     
      end

    end  
  end
end
