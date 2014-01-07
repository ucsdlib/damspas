class Ability 
  include Hydra::Ability
  def custom_permissions

    # Enforced gated read access for dams:Object
    can [:read], DamsObject do |obj|
        test_read(obj.id)
    end

    # Enforced gated update access for dams:Object
    can [:update], DamsObject do |obj|
        test_edit(obj.id)
    end

    def create_permissions
      #can :create, :all if user_groups.include? 'registered'
    end
    
    # Enforce creation for dams:Object with curator roles, like dams-curator, dams-rci, dams-manager-admin etc.
    can :create, DamsObject do |obj|
    	result = false
        group_intersection = user_groups & Rails.configuration.curator_groups
        if(!group_intersection.empty?)
            result = true
            unit = obj.units
            if(!unit.nil? && !unit.code.blank?)
                unit_code = unit.code.first
                if !(user_groups.include?(Rails.configuration.super_role) || user_groups.include?(unit_code) || (unit_code.include?("dlp") && user_groups.include?("dams-curator")))
                    result = false;
                end
                logger.debug("[CANCAN] #{unit_code} DamsObject creation decision: #{result}")
            end
        end
        logger.debug("[CANCAN] DamsObject creation decision: #{result}: #{obj.units}")
        result
    end

    if current_user.new_record? || current_user.anonymous   #Anonymous user
      can [:solr], DamsObject
      can [:read], DamsUnit
      can [:read], DamsCopyright
      can [:read], DamsOtherRight
      can [:read], DamsLicense
      can [:read], DamsStatute
      can [:read], DamsAssembledCollection
      can [:read], DamsProvenanceCollection
      can [:read], DamsProvenanceCollectionPart
      can [:read], DamsSourceCapture
      can [:read], DamsCartographics
      can [:read], DamsCulturalContext
      can [:read], DamsTechnique
      can [:read], DamsIconography
      can [:read], DamsBuiltWorkPlace
      can [:read], DamsScientificName
      can [:read], DamsStylePeriod
      can [:read], MadsPersonalName
      can [:read], MadsComplexSubject
      can [:read], MadsTopic
      can [:read], MadsTemporal
      can [:read], MadsFamilyName
      can [:read], MadsCorporateName      
      can [:read], MadsConferenceName   
      can [:read], MadsName
      can [:read], MadsOccupation
      can [:read], MadsGenreForm
      can [:read], MadsGeographic
      can [:read], MadsScheme
      can [:read], MadsAuthority
      can [:read], MadsLanguage
    else  #login user
    #can [:read, :create, :update], DamsObject
      can [:read, :create, :update], DamsUnit
      can [:read, :create, :update], DamsFunction
      can [:read, :create, :update], DamsCulturalContext
      can [:read, :create, :update], DamsTechnique
      can [:read, :create, :update], DamsIconography
      can [:read, :create, :update], DamsBuiltWorkPlace
      can [:read, :create, :update], DamsScientificName
      can [:read, :create, :update], DamsStylePeriod
      can [:read, :create, :update], DamsCopyright
      can [:read, :create, :update], DamsOtherRight
      can [:read, :create, :update], DamsLicense
      can [:read, :create, :update], DamsStatute
      can [:read, :create, :update], DamsAssembledCollection
      can [:read, :create, :update], DamsProvenanceCollection
      can [:read, :create, :update], DamsProvenanceCollectionPart
      can [:read, :create, :update], DamsSourceCapture
      can [:read, :create, :update], DamsCartographics
      can [:read, :create, :update], MadsPersonalName
      can [:read, :create, :update], MadsFamilyName
      can [:read, :create, :update], MadsCorporateName      
      can [:read, :create, :update], MadsConferenceName    
      can [:read, :create, :update], MadsName    
      can [:read, :create, :update], SolrDocument
      can [:read, :create, :update], MadsComplexSubject
      can [:read, :create, :update], MadsTopic
      can [:read, :create, :update], MadsTemporal
      can [:read, :create, :update], MadsOccupation
      can [:read, :create, :update], MadsGenreForm
      can [:read, :create, :update], MadsGeographic      
      can [:read, :create, :update], MadsScheme
      can [:read, :create, :update], MadsAuthority
      can [:read, :create, :update], MadsLanguage
    end
  end
end
