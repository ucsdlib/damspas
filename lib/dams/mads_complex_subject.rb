require 'active_support/concern'

module Dams
  module MadsComplexSubject
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type MADS.ComplexSubject
      map_predicates do |map|
        map.comp_list(:in => MADS, :to => 'componentList', :class_name=>'MadsComponentList')
      end

      def componentList
        comp_list.first || comp_list.build
      end      
      accepts_nested_attributes_for :topic, :temporal, :genreForm, :geographic, :occupation, :personalName, :conferenceName, :corporateName, :familyName, :genericName, :scheme
      def serialize
        graph.insert([rdf_subject, RDF.type, MADS.ComplexSubject]) if new?
        super
      end
      delegate :topic_attributes=, to: :componentList
      alias_method :topic, :componentList

      delegate :temporal_attributes=, to: :componentList
      alias_method :temporal, :componentList

      delegate :genreForm_attributes=, to: :componentList
      alias_method :genreForm, :componentList
      
      delegate :geographic_attributes=, to: :componentList
      alias_method :geographic, :componentList
 
      delegate :occupation_attributes=, to: :componentList
      alias_method :occupation, :componentList

      delegate :personalName_attributes=, to: :componentList
      alias_method :personalName, :componentList

      delegate :conferenceName_attributes=, to: :componentList
      alias_method :conferenceName, :componentList

      delegate :corporateName_attributes=, to: :componentList
      alias_method :corporateName, :componentList
      
      delegate :familyName_attributes=, to: :componentList
      alias_method :familyName, :componentList

      delegate :genericName_attributes=, to: :componentList
      alias_method :genericName, :componentList

            
      def insert_component_list(solr_doc)
        begin
          el = componentList
          idx = 0
          while idx < el.size
            elem = el[idx]          
            #if elem.class.name.include? name
            if !elem.class.name.include? "RDF::URI"
              field_name = uncapitalize(elem.class.name.gsub!("Internal", "").gsub!("Mads", ""))
              if(elem.name.nil?)
          		  return nil
          	  elsif(elem.name.first == nil || elem.name.first.size > elem.name.size )
            	  #return elem.name.first
            	  Solrizer.insert_field(solr_doc, "complexSubject_0_#{idx}_#{field_name}", elem.name.first)	
          	  else
          		  #return elem.name.to_s
          		  Solrizer.insert_field(solr_doc, "complexSubject_0_#{idx}_#{field_name}", elem.name.first)	
              end
            end
            idx += 1
          end       
        rescue Exception => e
          #puts "Error: #{e}"
        end
      end

	  def uncapitalize(field)
	    field[0, 1].downcase + field[1..-1]
	  end
                                                                 
      def to_solr (solr_doc={})
        if componentList != nil
          insert_component_list(solr_doc)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }        
        solr_base solr_doc
      end
    end
    class MadsComponentList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.topic(:in=> MADS, :to =>"Topic", :class_name => "MadsTopicInternal")
        map.temporal(:in=> MADS, :to =>"Temporal", :class_name => "MadsTemporalInternal")        
        map.genreForm(:in=> MADS, :to =>"GenreForm", :class_name => "MadsGenreFormInternal")
        map.geographic(:in=> MADS, :to =>"Geographic", :class_name => "MadsGeographicInternal")
        map.occupation(:in=> MADS, :to =>"Occupation", :class_name => "MadsOccupationInternal")        
        map.personalName(:in=> MADS, :to =>"PersonalName", :class_name => "MadsPersonalNameInternal")        
        map.conferenceName(:in=> MADS, :to =>"ConferenceName", :class_name => "MadsConferenceNameInternal")
        map.corporateName(:in=> MADS, :to =>"CorporateName", :class_name => "MadsCorporateNameInternal")
        map.familyName(:in=> MADS, :to =>"FamilyName", :class_name => "MadsFamilyNameInternal")
        map.genericName(:in=> MADS, :to =>"Name", :class_name => "MadsNameInternal")
        
        #map.iconography(:in=> DAMS, :to =>"Iconography", :class_name => "MadsIconographyInternal")
        #map.scientificName(:in=> DAMS, :to =>"ScientificName", :class_name => "MadsScientificNameInternal")
        #map.technique(:in=> DAMS, :to =>"Technique", :class_name => "MadsTechniqueInternal")
        #map.builtWorkPlace(:in=> DAMS, :to =>"BuiltWorkPlace", :class_name => "MadsBuiltWorkPlaceInternal")
        #map.culturalContext(:in=> DAMS, :to =>"CulturalContext", :class_name => "MadsCulturalContextInternal")
        #map.stylePeriod(:in=> DAMS, :to =>"StylePeriod", :class_name => "MadsStylePeriodInternal")
        #map.function(:in=> DAMS, :to =>"Function", :class_name => "MadsFunctionInternal")        
      end
      accepts_nested_attributes_for :topic, :temporal, :genreForm, :geographic, :occupation, :personalName, :conferenceName, :corporateName, :familyName, :genericName
    end
  end
end
