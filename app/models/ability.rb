class Ability 
  include Hydra::Ability
  def custom_permissions
  	if current_user.new_record?  #Anonymous user
  		can [:read], DamsObject
  	else  #login user
    	can [:read, :create, :update], DamsObject
    	can [:read, :create, :update], DamsRepository
    end
  end
end
