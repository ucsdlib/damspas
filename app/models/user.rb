require 'rest-client'
require 'json'

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
logger.warn "dev: uid=#{uid}"
    email = access_token['info']['email'] || "#{uid}@ucsd.edu"
    provider = access_token.provider
    u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email)
    u.groups = ['developer-authenticated']
    u
  end

  def self.find_or_create_for_shibboleth(access_token, signed_in_resource=nil)
    uid = access_token.uid
    email = access_token['info']['email'] || "#{uid}@ucsd.edu"
    provider = access_token.provider
    u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email)
    u.groups = ['shibboleth-authenticated']
    u
  end

  def self.anonymous(ip)
    u = User.where(:uid => 'anonymous',:provider => 'anonymous').first || User.create(:uid => 'anonymous',:provider => 'anonymous', :email => 'anonymous')
    role = role_from_ip(ip)
    logger.warn "anonymous, role from ip: #{role}"
    u.groups = [ role ]
    u
  end

  def groups
    if @group_list == nil
      @group_list = ldap_groups( uid )
    end
    @group_list || ['unknown']
  end
  def groups=(g)
    @group_list = g
  end

  def ldap_groups( uid )
    begin
      username = uid
      if username.index("@") > -1
        username = username.slice( 0, username.index("@") )
      end
      baseurl = ActiveFedora.fedora_config.credentials[:url]
      baseurl = baseurl.gsub(/\/fedora$/,'')
      url = "#{baseurl}/api/client/info?user=#{username}&format=json"
      json = RestClient.get(url)
      obj = JSON.parse(json)
      obj['memberOf']
    rescue Exception => e
      logger.warn "Error looking up LDAP groups #{e.to_s}"
      []
    end
  end
  def self.role_from_ip( ip )
    if Rails.configuration.public_ips.include? ip
      return "public"
    else
      Rails.configuration.local_ip_blocks.each do |block|
        if ip.start_with? block
          return "local"
        end
      end
    end
    return "public"
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account. 
  def to_s
    uid
  end
end
