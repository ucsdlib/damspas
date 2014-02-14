class DamsUnit < ActiveFedora::Base
  include Hydra::AccessControls::Permissions

  has_metadata 'damsMetadata', :type => DamsUnitDatastream
  has_attributes :group,:name,:description,:uri,:code, datastream: :damsMetadata, multiple: true
  
  #lowercase the code
  #before_save { self.code = self.code.to_s.downcase! }
  
  # all unit properties are currently required
  validates :name, presence: true
  validates :description, presence: true
  validates :uri, presence: true
  validates :code, presence: true
  
end
