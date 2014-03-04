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

  def self.find_or_create_for_developer(access_token, signed_in_resource=nil)
    begin
      uid = access_token.uid
      email = access_token['info']['email'] || "#{uid}@ucsd.edu"
      provider = access_token.provider
    rescue Exception => e
      logger.warn "developer: #{e.to_s}"
      uid = 1
      email = "zombie@ucsd.edu"
      provider = "developer"
    end
    @anonymous = false
    u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email)
    u
  end

  def self.find_or_create_for_shibboleth(access_token, signed_in_resource=nil)
    begin
      uid = access_token.uid
      email = access_token['info']['email'] || "#{uid}@ucsd.edu"
      provider = access_token.provider
    rescue Exception => e
      logger.warn "shibboleth: #{e.to_s}"
    end
    @anonymous = false
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
    role = role_from_ip(ip)
    u = User.where(:uid => role, :provider => 'anonymous').first || User.create(:uid => role, :provider => 'anonymous', :email => role + '@anonymous')
    u.anonymous = true
	u.groups = [role]
    u
  end

  def groups
    if @group_list == nil
      if provider == "developer"
        @group_list = Rails.configuration.developer_groups
      elsif provider == "anonymous"
        @group_list = [ uid ]
      elsif provider == "shibboleth"
        @group_list = ['shibboleth-authenticated']
      else
        @group_list = Rails.configuration.unknown_groups
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
      if !username.blank? && username.index("@") != nil
        username = username.slice( 0, username.index("@") )
      end
      baseurl = ActiveFedora.fedora_config.credentials[:url]
      baseurl = baseurl.gsub(/\/fedora$/,'')
      url = "#{baseurl}/api/client/info?user=#{username}&format=json"
      json = RestClient.get(url)
      obj = JSON.parse(json)
      logger.warn "ldap_groups(#{uid}): #{obj}"
      obj['memberOf']
    rescue Exception => e
      logger.warn "Error looking up LDAP groups for #{uid}: #{e.to_s}"
      e.backtrace.each do |line|
        logger.warn line
      end
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
