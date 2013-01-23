class User < ActiveRecord::Base
# Connects this user object to Hydra behaviors. 
 include Hydra::User
# Connects this user object to Blacklights Bookmarks. 
 include Blacklight::User
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :provider, :uid
  # attr_accessible :title, :body

  def self.find_or_create_for_developer(access_token, signed_in_resource=nil)
    uid = access_token.uid
    email = access_token['info']['email'] || "#{uid}@ucsd.edu"
    provider = access_token.provider
    User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider,:email=email)
  end
  def self.find_or_create_for_shibboleth(access_token, signed_in_resource=nil)
    uid = access_token.uid
    provider = access_token.provider
    User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider)
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account. 
  def to_s
    uid
  end
end
