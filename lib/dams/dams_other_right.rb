require 'active_support/concern'

module Dams
  module DamsOtherRight
    extend ActiveSupport::Concern
    include ModelHelper
    included do
      #rdf_type DAMS.OtherRights
	  map_predicates do |map|
	    map.basis(:in => DAMS, :to => 'otherRightsBasis')
	    map.note(:in => DAMS, :to => 'otherRightsNote')
	    map.uri(:in => DAMS, :to => 'otherRightsURI')
	    map.restriction_node(:in => DAMS, :to=>'restriction', :class_name => 'DamsRestriction')
	    map.permission_node(:in => DAMS, :to=>'permission', :class_name => 'DamsPermission')
	    map.relationship(:in => DAMS, :class_name => 'DamsRelationshipInternal')
	  end
#      rdf_subject { |ds|
#        if ds.pid.nil?
#          RDF::URI.new
#        else
#          RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
#        end
#      }

      accepts_nested_attributes_for :relationship, :permission_node, :restriction_node

      def serialize
        check_type( graph, rdf_subject, DAMS.OtherRights )
        super
      end

	  def name
	    relationship[0] ? relationship[0].name : []
	  end
	  def name=(val)
	    if relationship[0] == nil
	      relationship.build
	    end
	    if val.class == Array
	    	val = val.first
	    end
	    if(!val.include? "#{Rails.configuration.id_namespace}")
	    	val = "#{Rails.configuration.id_namespace}#{val}"
	    end
	    relationship[0].name = RDF::Resource.new(val)
	  end
	  def role
	    relationship[0] ? relationship[0].role : []
	  end
	  def role=(val)
	    if relationship[0] == nil
	      relationship.build
	    end
	    if val.class == Array
	    	val = val.first
	    end	    
	    if(!val.include? "#{Rails.configuration.id_namespace}")
	    	val = "#{Rails.configuration.id_namespace}#{val}"
	    end
	    relationship[0].role = RDF::Resource.new(val)
	  end   

	  def insertRelationship ( solr_doc, prefix, relationships )
	
	    # build map: role => [name1,name2]
	    rels = {}
	    relationships.map do |relationship|
	      obj = relationship.name.first.to_s      
	
	      rel = nil
		  if !relationship.corporateName.first.nil?
		    rel = relationship.corporateName
		  elsif !relationship.personalName.first.nil?
		    rel = relationship.personalName
		  elsif !relationship.conferenceName.first.nil?
		    rel = relationship.conferenceName
		  elsif !relationship.familyName.first.nil?
		    rel = relationship.familyName 	     	        
	      elsif !relationship.name.first.nil?
		    rel = relationship.name    
		  end
	
	      foo = rel.to_s
	      if rel != nil && (rel.first.nil? || rel.first.name.first.nil?)
	        rel = relationship.load  
	      end
	
	      if ( rel != nil )
	        if(rel.to_s.include? 'Internal')
	            name = rel.first.name.first.to_s
	        else
	            name = rel.name.first.to_s
	        end
	
	        # retrieval
	               
	        begin        
	          relRole = relationship.role.first.name.first.to_s
	          foo = relRole.to_s
	          
	          # display     
	        
	          if !relRole.nil? && relRole != ''
	            roleValue = relRole
	          else 
	            role = relationship.loadRole
	            if role != nil
	              roleValue = role.name.first.to_s
	            end
	          end
	          Solrizer.insert_field( solr_doc, "relationship_name", name )
	          Solrizer.insert_field(solr_doc, "relationship_role", roleValue)
	          if rels[roleValue] == nil
	            rels[roleValue] = [name]
	          else
	            rels[roleValue] << name
	          end
	        rescue Exception => e
	          puts "trapping role error in relationship"
	          puts e.backtrace
	        end
	      end
	    end
	
	    # sort names
	    rels.each_key do |role|
	      rels[role] = rels[role].sort
	    end
	
	    # add to solr
	    Solrizer.insert_field( solr_doc, "#{prefix}relationship_json", rels.to_json )
	  end
  
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'basis', basis)
        Solrizer.insert_field(solr_doc, 'uri', uri)
        Solrizer.insert_field(solr_doc, 'note', note)
	    Solrizer.insert_field(solr_doc, "permissionType", permissionType)
	    Solrizer.insert_field(solr_doc, "permissionBeginDate", permissionBeginDate)
	    Solrizer.insert_field(solr_doc, "permissionEndDate", permissionEndDate)
	    Solrizer.insert_field(solr_doc, "restrictionType", restrictionType)
	    Solrizer.insert_field(solr_doc, "restrictionBeginDate", restrictionBeginDate)
	    Solrizer.insert_field(solr_doc, "restrictionEndDate", restrictionEndDate)
	    #if !relationship.nil? && !relationship[0].nil?
		#	Solrizer.insert_field(solr_doc, "relationship_role", relationship.first.loadRole.name)
	    #	Solrizer.insert_field(solr_doc, "relationship_name", relationship.first.load.name)
	    #end
	    
	    insertRelationship solr_doc, "", relationship
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }	          
	   # relationship.map do |relationship|
	   #   Solrizer.insert_field(solr_doc, 'decider', relationship.load.name )
	   # end
	    return solr_doc                      
      end
    end
  end
end
