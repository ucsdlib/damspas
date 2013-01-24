class DamsRepository
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  attr_accessor :id, :title, :description, :uri
  def initialize(attributes = {})
     attributes.each do |name, value|
       send("#{name}=",value)
     end
  end
  
  def persisted?
    true
  end
  def self.all
    CONSTANTLY_BAD_REPOSITORIES
  end
  
end