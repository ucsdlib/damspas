class DamsRepository
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  attr_accessor :id, :name, :description, :uri
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
 
  def self.find id
    obj = self.all.select { |x| x.id == id }.first
  
    if obj.nil?
      raise ActiveFedora::ObjectNotFoundError, "Unable to find #{id}"
    end

    obj
  end 
end
