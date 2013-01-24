class Ability 
  include Hydra::Ability
  def custom_permissions
    can :read, DamsObject
  end
end
