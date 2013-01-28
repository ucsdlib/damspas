require 'datastreams/dams_vocabulary'
require 'datastreams/mads_vocabulary'


module RDF
  # This enables RDF to respond_to? :value
  def self.value
    self[:value]
  end
end

