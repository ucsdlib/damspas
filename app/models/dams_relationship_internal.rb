class DamsRelationshipInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include Dams::DamsHelper
    rdf_type DAMS.Relationship
    map_predicates do |map|
      map.name(:in=> DAMS, :class_name => 'MadsNameInternal')
      map.corporateName(:in => DAMS, :class_name => 'MadsCorporateNameInternal')       
      map.personalName(:in => DAMS, :class_name => 'MadsPersonalNameInternal')
      map.conferenceName(:in => DAMS, :class_name => 'MadsConferenceNameInternal')   
      map.familyName(:in => DAMS, :class_name => 'MadsFamilyNameInternal')      
      map.role(:in=> DAMS, :class_name => 'MadsAuthorityInternal')
    end
	
  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }


 	accepts_nested_attributes_for :name, :personalName, :corporateName, :conferenceName, :familyName, :role
 
    def load
      relName = nil
      if !name.first.nil?
        relName = loadRdfObjects name, MadsName
      elsif !personalName.first.nil?
        relName = loadRdfObjects personalName, MadsPersonalName
      elsif !corporateName.first.nil?
        relName = loadRdfObjects corporateName, MadsCorporateName
      elsif !conferenceName.first.nil?
        relName = loadRdfObjects conferenceName, MadsConferenceName
      elsif !familyName.first.nil?
        relName = loadRdfObjects familyName, MadsFamilyName
      end
      relName.first
    end
    
    def loadRole
      loadRdfObjects(role, MadsAuthority).first
    end   
    
	def pid
	   rdf_subject.to_s.gsub(/.*\//,'')
	end
	def persisted?
	    rdf_subject.kind_of? RDF::URI
	end      
end
