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
  attr_accessible :email, :provider, :uid, :groups

  # attr_accessible :title, :body
  attr_accessible :anonymous

  def self.find_or_create_for_developer(access_token, signed_in_resource=nil)
    uid = access_token.uid
    @anonymous = false
    email = access_token['info']['email'] || "#{uid}@ucsd.edu"
    provider = access_token.provider
    u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email)
    u
  end

  def self.find_or_create_for_shibboleth(access_token, signed_in_resource=nil)
    uid = access_token.uid
    @anonymous = false
    email = access_token['info']['email'] || "#{uid}@ucsd.edu"
    provider = access_token.provider
    u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email)
    u
  end

  def anonymous=(bool)
    @anonymous=bool
  end
  def anonymous
    @anonymous
  end
  def self.anonymous(ip)
    u = User.where(:uid => 'anonymous',:provider => 'anonymous').first || User.create(:uid => 'anonymous',:provider => 'anonymous', :email => 'anonymous')
    role = role_from_ip(ip)
    logger.warn "anonymous, role from ip: #{role}"
    u.groups = [ role ]
    u.anonymous = true
    u
  end

  def groups
    if @group_list == nil
      if provider == "developer"
        @group_list = ['developer-authenticated','dams-curator','dams-manager-user']
      elsif provider == "shibboleth"
        @group_list = ['shibboleth-authenticated']
      else
        @group_list = ['unknown']
      end
    end
    ldap = ldap_groups(uid)
    if ldap != nil && ldap.kind_of?(Array)
      @group_list.concat( ldap )
    end
    @group_list
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
