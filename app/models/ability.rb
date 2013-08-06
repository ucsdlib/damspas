class Ability 
  include Hydra::Ability
  def custom_permissions
  	if current_user.new_record?  #Anonymous user
  		can [:read], DamsObject
  		can [:read], DamsUnit
  		can [:read], DamsCopyright
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
  		can [:read], MadsPersonalName
  		can [:read], SolrDocument
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
    	can [:read, :create, :update, :view], DamsObject
    	can [:read, :create, :update, :view], DamsUnit
      can [:read, :create, :update, :view], DamsFunction
      can [:read, :create, :update, :view], DamsCulturalContext
      can [:read, :create, :update, :view], DamsTechnique
      can [:read, :create, :update, :view], DamsIconography
      can [:read, :create, :update, :view], DamsBuiltWorkPlace
    	can [:read, :create, :update], DamsCopyright
    	can [:read, :create, :update], DamsLicense
    	can [:read, :create, :update], DamsStatute
  		can [:read, :create, :update], DamsAssembledCollection
  		can [:read, :create, :update], DamsProvenanceCollection
  		can [:read, :create, :update], DamsProvenanceCollectionPart
  		can [:read, :create, :update], DamsSourceCapture
  		can [:read, :create, :update], DamsCartographics
  		can [:read, :create, :update, :view], MadsPersonalName
  		can [:read, :create, :update, :view], MadsFamilyName
  		can [:read, :create, :update, :view], MadsCorporateName  		
  		can [:read, :create, :update, :view], MadsConferenceName  	
  		can [:read, :create, :update, :view], MadsName  	
  		can [:read, :create, :update], SolrDocument
  		can [:read, :create, :update, :view], MadsComplexSubject
  		can [:read, :create, :update, :view], MadsTopic
  		can [:read, :create, :update, :view], MadsTemporal
  		can [:read, :create, :update, :view], MadsOccupation
  		can [:read, :create, :update, :view], MadsGenreForm
  		can [:read, :create, :update, :view], MadsGeographic  		
  		can [:read, :create, :update, :view], MadsScheme
  		can [:read, :create, :update, :view], MadsAuthority
  		can [:read, :create, :update, :view], MadsLanguage
    end
  end
end
