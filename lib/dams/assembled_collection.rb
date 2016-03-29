require 'active_support/concern'

module Dams
  module AssembledCollection
   extend ActiveSupport::Concern
    
  included do
    include ModelHelper
    rdf_type DAMS.AssembledCollection
    rdf_subject { |ds|
      if ds.pid.nil?
        RDF::URI.new
      else
        RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
      end
    }

    map_predicates do |map|
        map.title(:in => DAMS, :to => 'title', :class_name => 'MadsTitle')
        map.date(:in => DAMS, :to=>'date', :class_name => 'DamsDate')
        map.relationship(:in => DAMS, :to=>'relationship', :class_name => 'DamsRelationshipInternal')
        map.language(:in=>DAMS, :class_name => 'MadsLanguageInternal')
        map.visibility(:in=>DAMS)
        map.resource_type(:in=>DAMS, :to => 'typeOfResource')

        # notes
        map.note(                       :in => DAMS, :to=>'note',                        :class_name => 'DamsNoteInternal')
        map.custodialResponsibilityNote(:in => DAMS, :to=>'custodialResponsibilityNote', :class_name => 'DamsCustodialResponsibilityNoteInternal')
        map.preferredCitationNote(      :in => DAMS, :to=>'preferredCitationNote',       :class_name => 'DamsPreferredCitationNoteInternal')
        map.scopeContentNote(           :in => DAMS, :to=>'scopeContentNote',            :class_name => 'DamsScopeContentNoteInternal')

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
        map.commonName(:in => DAMS, :class_name => 'DamsCommonNameInternal')
        map.scientificName(:in => DAMS, :class_name => 'DamsScientificNameInternal')
        map.stylePeriod(:in => DAMS, :class_name => 'DamsStylePeriodInternal')
        map.technique(:in => DAMS, :class_name => 'DamsTechniqueInternal')
        map.temporal(:in => DAMS, :class_name => 'MadsTemporalInternal')
        map.topic(:in => DAMS, :class_name => 'MadsTopicInternal')
        map.lithology(:in => DAMS, :class_name => 'DamsLithologyInternal')
        map.series(:in => DAMS, :class_name => 'DamsSeriesInternal')
        map.cruise(:in => DAMS, :class_name => 'DamsCruiseInternal')
        map.anatomy(:in => DAMS, :class_name => 'DamsAnatomyInternal')

        
        # subject names
        map.name(:in => DAMS, :class_name => 'MadsNameInternal')
        map.conferenceName(:in => DAMS, :class_name => 'MadsConferenceNameInternal')
        map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')
        map.familyName(:in => DAMS, :class_name => 'MadsFamilyNameInternal')
        map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')

        # related resources and events
        map.relatedResource(:in => DAMS, :class_name => 'DamsRelatedResourceInternal')
        map.event(:in=>DAMS, :class_name => 'DamsEventInternal')

        # unit collections
	    map.unit(:in => DAMS, :to=>'unit', :class_name => 'DamsUnitInternal')
        map.collection(:in => DAMS)
        map.assembledCollection(:in => DAMS, :class_name => 'DamsAssembledCollectionInternal')
        map.provenanceCollection(:in => DAMS, :class_name => 'DamsProvenanceCollectionInternal')
        map.provenanceCollectionPart(:in => DAMS, :class_name => 'DamsProvenanceCollectionPartInternal')
        
        
       # child parts
        map.part_node(:in=>DAMS,:to=>'hasPart')
        map.provenanceCollection_node(:in=>DAMS,:to=>'hasProvenanceCollection')

        # related collections
        map.relatedCollection(:in => DAMS)

        # related objects
        map.object(:in => DAMS, :to => 'hasObject')
      end

   

  accepts_nested_attributes_for :title, :date, :relationship, :language, :visibility, :resource_type,
                      :note, :custodialResponsibilityNote, :preferredCitationNote, :scopeContentNote, 
                      :complexSubject, :builtWorkPlace, :culturalContext, :function, :genreForm, :geographic, 
                      :iconography, :occupation, :commonName, :scientificName, :stylePeriod, :technique,
                      :temporal, :topic, :lithology, :series, :cruise, :anatomy,
                      :name, :conferenceName, :corporateName, :familyName, :personalName, :relatedResource,
                      :unit, :provenanceCollection, :provenanceCollectionPart, :part_node,:file,:provenanceCollection_node, :allow_destroy => true  
  

      def serialize
        check_type( graph, rdf_subject, DAMS.AssembledCollection )
        if(!@unitURI.nil?)
	      if new?
	        graph.insert([rdf_subject, DAMS.unit, @unitURI])
	      else
	        graph.update([rdf_subject, DAMS.unit, @unitURI])
	      end
	    end    
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
        if(!@relResourceURI.nil?)
			if(@relResourceURI.class == Array)
				@relResourceURI.each do |rel|
			        graph.insert([rdf_subject, DAMS.relatedResource, rel])
			    end
			else
			      if new?
			        graph.insert([rdf_subject, DAMS.relatedResource, @relResourceURI])
			      else
			        graph.update([rdf_subject, DAMS.relatedResource, @relResourceURI])
			      end			
			end
	    end	    
        # if(!@provenanceCollURI.nil?)
        #   if new?
        #     graph.insert([rdf_subject, DAMS.provenanceCollection, @provenanceCollURI])
        #   else
        #     graph.update([rdf_subject, DAMS.provenanceCollection, @provenanceCollURI])
        #   end
        # end 
        if(!@provenanceCollURI.nil?)
          if new?
            graph.insert([rdf_subject, DAMS.provenanceCollection_node, @hasProvenanceCollectionURI])
          else
            graph.update([rdf_subject, DAMS.provenanceCollection_node, @hasProvenanceCollectionURI])
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
              puts "subtype" + @subType[i]
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
	              puts "nameType"
	              graph.insert([rdf_subject, RDF::URI.new("#{DAMS}#{@namesType[i].camelize(:lower)}"), crea])
	              i = i + 1
	          end
	      else
	          if new?
	            graph.insert([rdf_subject, RDF::URI.new("#{DAMS}#{@namesType[0].camelize(:lower)}"), @creatorURI])
	          else
	            graph.update([rdf_subject, RDF::URI.new("#{DAMS}#{@namesType[0].camelize(:lower)}"), @creatorURI])
	          end   
	      end                 
	    end     
	end
    end  
  end
end
